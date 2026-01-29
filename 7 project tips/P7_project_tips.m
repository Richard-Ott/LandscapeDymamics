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

%% Dealing with NaN's and 0 values in raster

% Sometimes you have parts of the sea as 0 values in the DEM, but it would
% be better to have them as NaN. Otherwise TT will try to calculate weird
% streams that flow in the flat sea.
% Let's remove 0 elevation values and make them NaN
DEM.Z(DEM.Z == 0) = nan;   % try to understand the logic of this line

% Sometimes you have RUSLE factors with many missing values (NaN's) in your
% area. Often it makes sense to simply assing the mean of all existing
% values to the missing pixels. That is a quick and easy solution to fill
% these gaps.

CfactorInterpolated = Cfactor;
CfactorInterpolated.Z(isnan(CfactorInterpolated.Z)) = mean(CfactorInterpolated.Z(:),'omitnan');

%% Don't forget to adjust your color map axis!!
% in the practicals we sometimes apply limits to the color maps. Only do
% that if there is a visual reason to do this. Do this for instance, if you
% have a few very high values that make it so that most of the values have
% the same color and you can't see patterns. As default, don't use a limit
% of the colormaps (caxis, clim). 

plotc(S,ksn)
colorbar

% this plot has a few very high values, realted to DEM artefacts. That's
% why we use a limit on the colormaps. Always play around with the value to
% make sure you get something that works well for your data.

plotc(S,ksn)
clim([0 100])
colorbar

%% How to use global lithologic map

GEO = GRIDobj();
GEO = crop(GEO, 'interactive');   % crop global map to your general region. This makes resampling and computation easier.
GEO = resample2utm(GEO,'zone', 'someUTMzone');
GEO = resample(GEO,DEM,'nearest');

% Here's the legend for the global lithologic map:
% 1 Unconsolidated sediments
% 2 Siliciclastic sedimentary rocks
% 3 Pyroclastics
% 4 Mixed sedimentary rocks
% 5 Carbonate sedimentary rocks
% 6 Evaporites
% 7 Acid volcanic rocks
% 8 Intermediate volcanic rocks
% 9 Basic volcanic rocks
% 10 Acid plutonic rocks
% 11 Intermediate plutonic rocks
% 12 Basic plutonic rocks
% 13 Metamorphics
% 14 Water Bodies
% 15 Ice and Glaciers
% nd No Data

% simplify map. IN YOUR REGION YOU PROBABLY WANT METAMORPHIC ROCKS
% SEPARATE (DIFFERENT FROM THE PRACTICAL). The only reason I grouped
% metamorphic and magmatic rocks in the practical, is because I knew that
% in the BW are very similar. 
ids = cell(6,1);                                % empty lithology ID matrix
ids{1} = 1;                                  % unconsolidated sediments
ids{2} = [7,8,9,10,11,12];                   % Magmatic
ids{3} = 2;                                  % siliciclastic sediments
ids{4} = 4;                                  % mixed sediments
ids{5} = 5;                                  % carbonates
ids{6} = 13;                                 % metamorphic
ids{7} = [3 6 14 15 16];                     % Other: evaporites, water, ice and no data
geo_names = {'unconsolidated  sediment','magmatic', 'siliciclastic  sediment', ...
    'mixed  sediment', 'carbonates', 'metamorphic','other'};



