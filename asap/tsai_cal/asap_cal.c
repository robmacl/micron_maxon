/*
Do calibration for ASAP.
This was derived from ccal.c 
ram 5/15/06

*/

#include <stdio.h>
#include "cal_main.h"
#include "math.h"

void      print_matlab_cp_cc_data (fp, cp, cc, sname)
    FILE     *fp;
    struct camera_parameters *cp;
    struct calibration_constants *cc;
{
  fprintf (fp, "       %s.f = %.6lf; %% [microns]\n\n", sname, cc->f);

  fprintf (fp, "       %s.kappa1 = %.6le;\n\n", sname, cc->kappa1);

  fprintf (fp, "       %s.T=[%.6lf,  %.6lf,  %.6lf]; %% [microns]\n\n",
	   sname, cc->Tx, cc->Ty, cc->Tz);

  fprintf (fp, "       %s.Rx = %.6lf;  %s.Ry = %.6lf;  %s.Rz = %.6lf; %% [deg]\n\n",
	   sname, cc->Rx * 180 / M_PI,
	   sname, cc->Ry * 180 / M_PI,
	   sname, cc->Rz * 180 / M_PI);

  fprintf (fp, "       %s.R = [\n", sname);
  fprintf (fp, "       %lg  %lg  %lg\n", cc->r1, cc->r2, cc->r3);
  fprintf (fp, "       %lg  %lg  %lg\n", cc->r4, cc->r5, cc->r6);
  fprintf (fp, "       %lg  %lg  %lg];\n\n", cc->r7, cc->r8, cc->r9);
  
  fprintf (fp, "       %s.sx = %.6lf;\n", sname, cp->sx);
  fprintf (fp, "       %s.Cxy = [%.6lf %.6lf]; %% [pixels]\n\n", sname, cp->Cx, cp->Cy);
 fprintf (fp, "       %s.dpxy = [%.6lf %.6lf]; %% [microns/pixel]\n\n", sname, cp->dpx, cp->dpy);
  fprintf (fp, "       %s.Tz_f = %.6lf; %% Tz/f\n\n", sname, cc->Tz / cc->f);
}

main (argc, argv)
    int       argc;
    char    **argv;
{
    FILE     *data_fd;

    int       i;

    if (argc != 4) {
      fprintf (stderr, "syntax: %s in_file struct_name out_file\n", argv[0]);
      exit (-1);
    }

    /* initialize the camera parameters (cp) with the appropriate camera constants */

    strcpy (camera_type, "ASAP");

    cp.Ncx = 10000;		/* [sel]        */
    cp.Nfx = 10000;		/* [pix]        */
    cp.dx = 6.0;		/* [microns/sel]     */
    cp.dy = 6.0;		/* [microns/sel]     */
    cp.dpx = cp.dx * cp.Ncx / cp.Nfx;	/* [microns/pix]     */
    cp.dpy = cp.dy;		/* [microns/pix]     */
    cp.Cx = 5000;		/* [pix]        */
    cp.Cy = 5000;		/* [pix]        */
    cp.sx = 1.0;		/* []		 */

    if ((data_fd = fopen (argv[1], "r")) == NULL) {
      fprintf (stderr, "%s: unable to open file \"%s\"\n", argv[0], argv[1]);
      exit (-1);
    }
    /* load up the calibration data (cd) from the given data file */
    load_cd_data (data_fd, &cd);
    fclose (data_fd);

    fprintf (stderr, "\ndata file: %s  (%d points)\n\n", argv[1], cd.point_count);

    noncoplanar_calibration_with_full_optimization();

    /* This is a way to calibrate forcing no radial distortion.  Do
       the full calibration, then force kappa1 to zero and calibrate
       only the extrinsic parameters.  This is necessary because
       kappa1 interacts with the linear magnification Tz/f factor.  We
       can fix this up by fudging Tz. */
#if 1
    cc.kappa1 = 0;
    noncoplanar_extrinsic_parameter_estimation ();
#endif

    FILE *out_fd;
    if ((out_fd = fopen (argv[3], "w")) == NULL) {
      fprintf (stderr, "%s: unable to output file \"%s\"\n", argv[0], argv[3]);
      exit (-1);
    }
    print_matlab_cp_cc_data (out_fd, &cp, &cc, argv[2]);
    print_error_stats (stderr);

    return 0;
}