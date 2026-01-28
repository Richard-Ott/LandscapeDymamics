% This practical is just to show you some tips and common problems when
% working on your project.
% In the practicals we were always using Matlab LiveScripts. This is mostly
% because they're nice for writing text and including pictures and
% interactive elements, such as buttons. Normally, when I code and work on
% a project I use a script (.m) file and not a LiveScript. LiveScripts take
% up more memory and processing power and also cannot be read by any text
% editor. Thus, I prefer using scripts.
% Richard Ott, 2026

%% load DEM
% in practical 1 you used the GRIDobj command to load a pre-loaded DEM. For
% your project either download a DEM tile via Opentopography or use
% readopentopo (Option 2, practical 1) to download your DEM.

DEM = readopentopo('extent',[6.78986 10.6535 47.4572 49.6447],...
    'interactive', false, 'demtype','COP90','apikey', 'COPY API KEY HERE');

% after you download your DEM once, save it !!! Don't download it every
% time again...
GRIDobj2geotiff(DEM,'somefilename.tif');

% once you saved it. Load the saved DEM in future runs of your code, instead
% of downloading again and again...

%% exporting files to ArcGIS
% Above you've seen the command on how to export raster to ArcGIS. However,
% you also have stream and divide networks and other data types. Sometimes
% it's nice to export these things to ArcGIS, because it allows you to
% include interactive elements in your Storymap.

% Here's how to export STREAMobj and DIVIDEobj to a shapefile and inlcude
% attributes you computed.

FD = FLOWobj(DEM);
S = STREAMobj(FD);
A = flowacc(FD);

so = streamorder(S,'strahler');  % calculate strahler order
ksn = loessksn(S,DEM,A);         % calcluate Ksn

% export streams with Ksn and Strahler order as attributes, check help to 
% to understand syntax of the function!
MS = STREAMobj2mapstruct(S,'seglength',300,...
                'attributes',{'Order' so @mean 'ksn' ksn @mean});
shapewrite(MS,'somefilename.shp')

%% saving workspace
% once you calculate something that takes a long time to run, or just in
% general, you can save your workspace. Then you don't need to rerun
% everything later

save('somefilename.mat')       % saves the entire workspace
save("file.mat","so","ksn")  % save specific variables

% use load command to load previously saved workspace (variables).

%% reprojecting things to UTM
% in TT things need to be in projected coordinate systems (usually we use
% UTM)

% in P1 we use reproject2utm, but without additional inputs
DEM = reproject2utm(DEM,90);

% This takes something in WGS (latitude longitude) and automatically
% projects it to UTM. If your DEM is small this function automatically
% figures out what the correct UTM zone for this raster is. But when you
% load a big raster (e.g., a RUSLE factor for whole Europe) that covers
% several UTM zones, you'll have to tell it what UTM zone to use. 
% 
% Check the help of reproject2utm on how to supply the UTM zone manually!

% BEFORE reprojecting you can also crop your DEM. This can be especially
% useful for big rasters (e.g. global RUSLE factors). 
DEM = crop(DEM, 'interactive');

% this lets you draw a rectangle and crop a raster.



