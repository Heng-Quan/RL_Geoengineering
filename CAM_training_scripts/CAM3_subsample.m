% CAM3 64x128 subsample to 32x64

clear,clc,close all

lon_index = 1:2:128;
lat_index = [2:2:32,33:2:64];
file_old = 'sst_HadOIBl_bc_64x128_clim_SOM_c021214.nc';
file_new = 'sst_HadOIBl_bc_32x64_clim_SOM_c021214.nc';
% file_old = 'cami_0000-01-01_64x128_T42_L26_SOM_c030918.nc';
% file_new = 'cami_0000-01-01_32x64_L26_SOM_c030918.nc';

info = ncinfo(file_old);
variables = info.Variables;

for i = 1:length(variables)
    variable = variables(i);
    dimensions = variable.Dimensions;
    var_old = ncread(file_old,variable.Name);
    if isequal(variable.Size,[128,64])
        dimensions(1).Length = 64;
        dimensions(2).Length = 32;
        var_new = var_old(lon_index,lat_index);
    elseif isequal(variable.Size,[128,64,12])
        dimensions(1).Length = 64;
        dimensions(2).Length = 32;
        var_new = var_old(lon_index,lat_index,:);
    elseif isequal(variable.Size,[128,64,1])
        dimensions(1).Length = 64;
        dimensions(2).Length = 32;
        var_new = var_old(lon_index,lat_index,:);
    elseif isequal(variable.Size,[128,26,64,1])
        dimensions(1).Length = 64;
        dimensions(3).Length = 32;
        var_new = var_old(lon_index,:,lat_index,:);
    elseif isequal(variable.Size,128)
        dimensions(1).Length = 64;
        var_new = ncread('cami_0000-09-01_32x64_L26_c030918.nc','lon');
    elseif isequal(variable.Size,64)
        dimensions(1).Length = 32;
        var_new = ncread('cami_0000-09-01_32x64_L26_c030918.nc','lat');
    else
        var_new = var_old;
    end
    
    if isempty(dimensions)
        nccreate(file_new,variable.Name,'Datatype',variable.Datatype);
    else
        ndim = length(variable.Size);
        dim_cell = cell(1,ndim*2);
        for j = 1:ndim
            dim_cell(2*j-1) = {dimensions(j).Name};
            dim_cell(2*j) = {dimensions(j).Length};
        end
        nccreate(file_new,variable.Name,'Dimensions',dim_cell,...
            'Datatype',variable.Datatype)
    end
    
    attributes = variable.Attributes;
    natt = length(attributes);
    for k = 1:natt
        if isequal(attributes(k).Name,'_FillValue')
           continue 
        end 
        ncwriteatt(file_new,variable.Name,...
            attributes(k).Name,attributes(k).Value);
    end
    
    ncwrite(file_new,variable.Name,var_new)
end

global_attributes = info.Attributes;
for k = 1:length(global_attributes)
    ncwriteatt(file_new,'/',...
        global_attributes(k).Name,global_attributes(k).Value);
end

% lat = ncread('cami_0000-09-01_32x64_L26_c030918.nc','lat');
% lon = ncread('cami_0000-09-01_32x64_L26_c030918.nc','lon');
% ncwrite(file_new,'lat',lat)
% ncwrite(file_new,'lon',lon)
