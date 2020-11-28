clear;
clc;

currentFolder = pwd;
path = [currentFolder,'\test images\'];
subpath = dir(path);

for i = 3:length(subpath)
    file =[path,subpath(i).name];
    RemoveHaze(file,subpath(i).name);
end
