% code I used o make the chi map for the course

DEMlarge = GRIDobj();
FDlarge  = FLOWobj(DEMlarge,'preprocess', 'carve');
Alarge   = flowacc(FDlarge);
Slarge   = STREAMobj(FDlarge,'minarea',minArea,'unit','mapunits');
Con_large= griddedcontour(DEMlarge,[180 180],true);
Schi_large= modify(Slarge,'upstreamto',Con_large);
chilarge = chitransform(Schi_large,Alarge,'mn',theta_ref);
chiMaplarge   = mapfromnal(FDlarge,Schi_large,chilarge);
chiMapclipped = resample(chiMaplarge,DEM);