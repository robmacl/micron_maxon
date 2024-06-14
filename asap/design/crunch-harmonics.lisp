;;; -*- Package: CL-USER -*-
#|
Due to some analysis, I've realized that there's a bunch of stuff in here
checking for sitations that can't actually happen.  If we are only concerned
with harmonics and IMD products of the modulation and aliases thereof, then the
entire spectral palette we are dealing with is the harmonics (multiples) of the
output rate.  Thus we could conveniently represent all of the frequencies as
integer multiples of the output rate.  Furthermore, the sinc response is zero
at all multiples of the output rate except for the modulation frequency, so the
only possible collision distance is zero.  

It is true that aliases are not in general harmonic, but we force this because
all of the signals and the sample rate are part of the same harmonic series.

A worthwhile test would be to test the overall system cross-coupling between
the channels by turning one output on and off.  This would validate the
interference model and also check for hardware cross-coupling.

|#

(in-package :cl-user)

(declaim (inline alias))
;;; Return alias of f after sampling at Fs.
(defun alias (f Fs)
  (declare (double-float f Fs))
  (let ((Fn (/ Fs 2)))
    (do ((res f (abs (- Fs res))))
	((<= res Fn) res)
	(declare (double-float res)))))

;; Old ASAP
(progn
  ;; antialias filter order and cutoff freq
  (defparameter antialias-order 2d0)
  (defparameter antialias-fc 4000d0)
  
  ;; With square wave drive, ideally there are no even harmonics.  We allow for
  ;; this much.
  (defparameter even-harmonic-suppression 0.038)
  
  ;; Additional attenuation of all harmonics.
  (defparameter harmonic-suppression 1d0)
  
  ;;; If we have two frequencies f1, f2, what is the amplitude of the f1+f2 and
  ;;; f1-f2 components relative to the weaker of the f1, f2 amplitudes?
  (defparameter intermodulation-efficency 1d-4))

;; New asap changes
(progn
  ;; antialias filter order and cutoff freq
  ;; Third order is an approximation of the effect of the new low corner in the
  ;; driver.  Actually that pole is at 15 kHz, so we would really do better. 
  (defparameter antialias-order 3d0)
  (defparameter antialias-fc 22d3))


;; Magnetic
#+nil
(progn
  (defparameter antialias-fc 8d3)
  (defparameter even-harmonic-suppression 1d-3)
  (defparameter harmonic-suppression 0.1d0)
  (defparameter intermodulation-efficency 1d-3))

(declaim (double-float antialias-fc antialias-order even-harmonic-suppression
		       harmonic-suppression intermodulation-efficency))

(declaim (inline antialias-response))
;; Approximate response of antialias filter at frequency h.
(defun antialias-response (h)
  (declare (double-float h))
  (let ((h-normed (/ h antialias-fc)))
    (if (> h-normed 1) ; filter approximation
	(expt (/ h-normed) antialias-order)
	1d0)))

(declaim (inline h-ampl))
(defun h-ampl (n)
  (declare (fixnum n))
  (* (/ (coerce n 'double-float))
     (if (oddp n) 1d0 even-harmonic-suppression)
     (if (= n 1) 1d0 harmonic-suppression)))

(declaim (start-block crunch) (optimize (speed 2)))

(defun sinc-response (f deci_Fs)
  (declare (double-float f deci_FS))
  (let ((x (max 1d-3 (/ (* pi f) deci_Fs))))
    (declare (type (double-float -1d6 1d6) x))
    (abs (/ (sin x) x))))

;;; Estimate the amplitude of interference with the VICTIM frequency by OTHER.
;;; The basic theory is that if VICTIM is the measurement frequency, and we
;;; look in a bandwidth VICTIM +/- bandwidth, do we find an interferer from a
;;; harmonic or IMD product of OTHER, taking into account aliasing?
;;;
(defun crunch-aux (victim other nh Fs ri)
  (declare (double-float victim other Fs) (fixnum nh ri))
  (let ((res 0d0)
	(deci_Fs (/ Fs (coerce ri 'double-float)))
	(victim (alias victim Fs))) ; Fundamental may be aliased 
    (declare (double-float res))
    (flet ((interfere (freq ampl)
	     (declare (double-float freq ampl))
	     (let ((dist (abs (- victim (alias freq Fs)))))
	       ; This is true, but slow.  In other words, the distance is
	       ; always a harmonic of deci_Fs due to our other constraints.
	       ; And the sinc response is zero at all harmonics of deci_Fs
	       ; except for the modulation freq.  So the only possible
	       ; collision is direct (after aliasing.
	       #+nil 
	       (assert (multiple-value-bind (q r) (round dist deci_Fs)
			 (< (abs r) 1e-6)))
	       (incf res (* ampl
			    (antialias-response freq)
			    (sinc-response dist deci_Fs))))))
      (declare (double-float res) (inline interfere))
      (do ((victim-h victim (+ victim-h (* victim 2)))
	   (num1 1 (1+ num1)))
	  ((> num1 nh))
	(declare (fixnum num1) (double-float victim-h))
	(let ((ampl1 (h-ampl num1)))
	  ;; Harmonics of victim can interfere with itself after aliasing, but
	  ;; only if the frequency offset is non-zero.
	  ;; ### not a real effect, but might hit spuriously due to
	  ;; imprecise arithmetic.  -- ram, 1-may-12
	  #+nil
	  (when (and (> num1 1) (/= (alias victim-h Fs) victim))
	    (interfere victim-h ampl1))
	  
	  ;; Model effect of intermodulation.  Only consider odd harmonics of
	  ;; other, as IMD is small anyway.
	  (do ((other-h other (+ other-h (* other 2)))
	       (num2 1 (+ num2 2)))
	      ((> num2 nh))
	    (declare (fixnum num2) (double-float other-h))
	    (let ((f-sum (+ victim-h other-h))
		  (f-diff (+ victim-h other-h))
		  (ampl (* intermodulation-efficency
			   (min ampl1 (h-ampl num2)))))
	      (interfere f-diff ampl)
	      (interfere f-sum ampl)))))
      
      ;; Harmonics of other directly intefere with victim, and for all that
      ;; matter with other = victim there is 100% interference.
      (do ((other-h other (+ other-h other))
	   (num2 1 (1+ num2)))
	  ((> num2 nh))
	(declare (fixnum num2) (double-float other-h))
	(interfere other-h (h-ampl num2))))
    res))


;;; Worst case interference is the max of the interference of each with the
;;; other.
(defun crunch (f1 f2 nh Fs ri)
  (declare (double-float f1 f2 Fs) (fixnum nh ri))
  (max (crunch-aux f1 f2 nh Fs ri)
       (crunch-aux f2 f1 nh Fs ri)))

(declaim (end-block))
(declaim (optimize (speed 1)))

;; Return vector of frequencies between fmin and fmax such that a whole number
;; of cycles fits in to whole number of sample periods with length shorter than
;; max_time.  The second value is lists of
;;   (rational-freq repeat-int ncycles)
;; where rational-freq is the precise rational representation of the frequency,
;; ncycles is the number of cycles that fit in the sample interval, and
;; repeat-int is the length of the repeat interval in sample cycles.
;;
;; Frequencies are further constrained so that a half-cycle is an integral
;; number of timebase ticks.
;;
(defun gen-freqs (fmin fmax timebase Fs max_time)
  (declare (rational fmin fmax Fs timebase))
  (let ((s-low (/ Fs fmin))
	(s-high (/ Fs fmax))
	(max-samps (truncate (* Fs max_time)))
	(res ()))
    ;; longest to shortest repeat interval (in samples)
    (do ((samps max-samps (1- samps)))
	((< samps s-high))
      (when t ; (= (logcount samps) 1) ; for power of 2 M
	;; lowest to highest number of cycles in this repeat interval
	(do ((divisor (ceiling samps s-low) (1+ divisor)))
	    (())
	  (let ((p-this (/ samps divisor)))
	    (when (< p-this s-high)
	      (return))
	    (let ((f-this (/ Fs p-this)))
	      (when (zerop (rem timebase (* f-this 2)))
		(pushnew (list f-this samps divisor) res)))))))
    (setq res (sort (remove-duplicates (nreverse res) :key #'first)
		    #'< :key #'first))
    (values
     (coerce (mapcar #'(lambda (x)
			 (coerce (first x) 'double-float)) res)
	     '(simple-array double-float (*)))
     (coerce res 'simple-vector))))


;; Return list of all of the sample rates over an interval that we can generate
;; using our timebase and sampling the specified number of channels.
(defun gen-sample-rates (Fs_min Fs_max timebase nchans)
  (declare (rational timebase) (integer nchans))
  (let* ((timebase_nchans (/ timebase nchans))
	 (max_divisor (floor timebase_nchans Fs_min))
	 (res ()))
    (do ((divisor (ceiling timebase_nchans Fs_max) (1+ divisor)))
	((> divisor max_divisor) res)
      (push (/ timebase_nchans divisor) res))))


;;; Reports the predicted output spectrum given alias and harmonic rolloff, but
;;; ignoring intermodulation.  This does not really summarize the design
;;; process because it doesn't indicate interferences and ignores
;;; intermodulation.  However, the similarity of this simulated spectrum and
;;; the real one lends confidence to the process.
(defun gen-spectrum (freqs Fs nh min-ampl)
  (let ((res ()))
    (dolist (freq freqs)
      (do ((h freq (+ h freq))
	   (num 1 (1+ num)))
	  ((> num nh))
	(push (list (alias h Fs) h freq num) res)))
    (setq res (sort res #'< :key #'first))
    (dolist (x res)
      (destructuring-bind (alias h fund nh) x
	(let ((ampl (* (h-ampl nh)
		       (antialias-response h))))
	  (when (> ampl min-ampl)
	    (format t "~8,2F ~7,5F (~8,2F, ~Dh ~,2F)~%"
		    alias ampl h nh fund)))))))


;;; Return a square double array the size of the freqs vector containing the
;;; pairwise interfrence between each pair of frequencies.  The array is of
;;; course symmetrical and has 1s on the diagonal.  If two frequencies have
;;; different repeat intervals, then the interference is also 1.
;;; 
(defun find-pair-if (Fs freqs info nh)
  (declare (type (simple-array double-float (*)) freqs)
	   (simple-vector info))
  (let* ((Fs-float (coerce Fs 'double-float))
	 (nfreqs (length freqs))
	 (res (make-array (list nfreqs nfreqs) :element-type 'double-float)))
    (declare (type (simple-array double-float (* *)) res))
    (dotimes (i1 nfreqs)
      (let ((f1 (aref freqs i1))
	    (ri (second (aref info i1))))
	(declare (fixnum ri))
	(setf (aref res i1 i1) 1d0)
	(do ((i2 (1+ i1) (1+ i2)))
	    ((= i2 nfreqs))
	  (let* ((f2 (aref freqs i2))
		 (ifr (if (= (the fixnum (second (aref info i2))) ri)
			  (crunch f1 f2 nh Fs-float ri)
			  1d0)))
	    (setf (aref res i1 i2) ifr)
	    (setf (aref res i2 i1) ifr)))))
    res))


;;; Given interference-pair array PAIR-IF and the indices CHOSEN corresponding
;;; to frequencies already chosen, find FNUM more frequencies mimizing the
;;; maximum pairwise interference between all of the frequencies.  We return
;;; the list of indices for all frequencies chosen and the maximum pairwise
;;; interference.  If for some reason we can't find that many frequencies we
;;; return (values 1d0 ())
;;;
(defun find-best-freqs (fnum chosen pair-if)
  (declare (type (simple-array double-float (* *)) pair-if)
	   (list chosen) (fixnum fnum))
  (if (zerop fnum)
      (values (reverse chosen) 0d0)
      (let ((nfreqs (array-dimension pair-if 0))
	    (best-if 1d0)
	    (best-chosen nil))
	(declare (double-float best-if))
	(dotimes (ix nfreqs)
	  (declare (fixnum ix))
	  (let ((max-if 0d0))
	    (declare (double-float max-if))
	    ;; find max interference between this and all chosen freqs
	    (dolist (jx chosen)
	      (declare (fixnum jx))
	      (setq max-if (max (aref pair-if ix jx) max-if)))
	    
	    (when (< max-if 1d0)
	      ;; If this freq is possible, find the rest of the frequencies we
	      ;; need by recursing.
	      (multiple-value-bind
		  (chosen max-rest)
		  (find-best-freqs (1- fnum) (cons ix chosen) pair-if)
		(declare (double-float max-rest))
		(setq max-if (max max-rest max-if))
		
		(when (< max-if best-if)
		  (setq best-if max-if  best-chosen chosen))))))
	
	(values best-chosen best-if))))


(defun dump-if-array (x)
  (let ((fnum (array-dimension x 0)))
    (dotimes (ix fnum)
      (format t "~7D" ix))
    (terpri)
    (dotimes (ix fnum)
      (format t "~D: " ix)
      (dotimes (jx (1+ ix))
	(format t "~2,1E " (aref x ix jx)))
      (terpri))))

(defun subset-if-array (x ixs)
  (let* ((fnum2 (length ixs))
	 (res (make-array (list fnum2 fnum2) :element-type 'double-float)))
    (dotimes (ix fnum2)
      (dotimes (jx fnum2)
	(setf (aref res ix jx)
	      (aref x (elt ixs ix) (elt ixs jx)))))
    res))


;;; Group the modulation frequencies so as to minimize interference between
;;; groups.  Lights are mounted in triads that move together, so their motion
;;; is higly correlated, minimizing the harm of interference.  It's the
;;; interference between triads that is more problematic.  What we do is
;;; greedily group the frequencies with the *WORST* interference.  The worst
;;; pairwise interference determines two frequencies, and the remaining
;;; frequency in that group is the worst interference on that row or column.
;;; This also implicitly creates the second partition as having lower in-group
;;; interference.
;;;
(defun group-freqs (best-fs best-info nh)
  (let* ((best-freqs (mapcar #'(lambda (x)
				 (coerce (first x) 'double-float))
			     best-info))
	 (b-p-if
	  (find-pair-if best-fs 
			(coerce best-freqs '(simple-array double-float (*)))
			(coerce best-info 'simple-vector)
			nh)))
    (format t "Pairwise interference:~%")
    (dump-if-array b-p-if)

    (let ((fnum (array-dimension b-p-if 0))
	  (mi 0)
	  (mj 0)
	  (max-if 0)
	  (mk 0)
	  (max2-if 0))

      ;; Worst pairwise interference 
      (dotimes (ix fnum)
	(dotimes (jx ix)
	  (let ((ifn (aref b-p-if ix jx)))
	    (when (> ifn max-if)
	      (setq mi ix  mj jx  max-if ifn)))))

      ;; Column containing max-if
      (do ((ix (1+ mj) (1+ ix)))
	  ((= ix fnum))
	  (unless (= ix mi)
	    (let ((ifn (aref b-p-if mj ix)))
	      (when (> ifn max2-if)
		(setq mk ix  max2-if ifn)))))

      ;; Row containing max-if
      (do ((ix (1+ mi) (1+ ix)))
	  ((= ix fnum))
	  (unless (= ix mj)
	    (let ((ifn (aref b-p-if ix mi)))
	      (when (> ifn max2-if)
		(setq mk ix  max2-if ifn)))))

      (let ((p1 (sort (list mi mj mk) #'<))
	    (p2 ()))
	(dotimes (i fnum)
	  (unless (member i p1)
	    (push i p2)))
	(setq p2 (reverse p2))

	(format t "Partition 1 = ~S, Partition 2 = ~S~%"
		p1 p2)

	(format t "~%Partition 1: ")
	(dolist (p1-ix p1)
	  (format t "~6,2F " (elt best-freqs p1-ix)))
	(terpri)
	(format t "Internal infererence:~%")
	(dump-if-array (subset-if-array b-p-if p1))

	(format t "~%Partition 2: ")
	(dolist (p2-ix p2)
	  (format t "~6,2F " (elt best-freqs p2-ix)))
	(terpri)
	(format t "Internal infererence:~%")
	(dump-if-array (subset-if-array b-p-if p2))


	(format t "~%Between partition interference:~%")
	(let ((max-bpi 0))
	  (dolist (p1-ix p1)
	    (dolist (p2-ix p2)
	      (let ((ifn (aref b-p-if p1-ix p2-ix)))
		(setq max-bpi (max ifn max-bpi))
		(format t "~2,1E " ifn)))
	    (terpri))
	  (format t "Max beteen paritions: ~2,1E~%" max-bpi))))))



;;; Find fnum output frequencies and a sample rate Fs, minimizing
;;; harmonic interference between the signals, and subject to various
;;; constraints:
;;;   f_min < f < f_max
;;;   Fs_min < Fs < Fs_max
;;;   repeat interval < max_time (lower bound on decimated sample rate)
;;;   Each f and the Fs must all be generated with integer divisors of timebase
;;;       taking into account that we are sequentially sampling nchans so the
;;;       actual sample rate is nchans * Fs
;;;
;;; nh controls how many harmonics we analyze for interference.

(defun opt-integer (fnum f_min f_max Fs_min Fs_max
			 &key (max_time 0.01d0) 
			 (timebase 10000000)
			 (fs_timebase timebase)
			 (nchans 8) (nh 50))
  (declare (fixnum fnum))
  (let ((best-Fs -1)
	(best-info nil)
	(best-if most-positive-double-float))
    (declare (double-float best-if))
    (dolist (Fs (gen-sample-rates Fs_min Fs_max fs_timebase nchans))
      ;; info is vector of lists (rational-freq repeat-int ncycles)
      (multiple-value-bind (freqs info)
			   (gen-freqs f_min f_max timebase Fs max_time)
	(declare (type (simple-array double-float (*)) freqs)
		 (simple-vector info))
	(let ((pair-if (find-pair-if Fs freqs info nh)))
	  (declare (type (simple-array double-float (* *)) pair-if))
	  (multiple-value-bind (fchoice pair-if)
			       (find-best-freqs fnum () pair-if)
	    (when (< pair-if best-if)
	      (setq best-if pair-if
		    best-info (mapcar #'(lambda (x) (aref info x)) fchoice)
		    best-Fs Fs))))))

    (let ((best-ri (second (first best-info))))
      (format t "interference ~,2G, Fs = ~6,2F (interval ~3,2F uS), repeat interval ~D~%"
	      best-if best-Fs (* (/ best-Fs) 1e6) best-ri)
      (format t "Output sample rate ~F, ADC rate ~,2F, ADC divisor ~D~%"
	      (/ best-Fs best-ri) (* best-Fs nchans)
	      (/ fs_timebase best-Fs nchans))
      (dolist (info best-info)
	(let ((hi (/ (* (first info) 2))))
	  (format t "F = ~6,2F, half-interval 1/2F = ~F us, divisor ~D~%"
		  (coerce (first info) 'double-float)
		  (* hi 1e6)
		  (* timebase hi)))))
    
    (let ((best-freqs (mapcar #'(lambda (x)
				   (coerce (first x) 'double-float))
			       best-info)))
      (gen-spectrum best-freqs
		    (coerce best-fs 'double-float)
		    nh (max (/ best-if 10) 1e-5))

      (when (> fnum 3)
	(group-freqs best-Fs best-info nh))

      
      (values best-if best-Fs best-info))))

