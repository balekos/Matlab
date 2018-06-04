function [o1,o2,o3,o4]= custom_read(filename)
fid=fopen(filename,'r');
nums=fread(fid,3,'int16'); %8a diabasei 3zeugh apo 2bytes dhladh synolo 6bytes
o1=fread(fid,nums(1),'*char')'; %h o1=fread(fid,nums(1),'char=>char');
o2=fread(fid,nums(2),'single');
o3=fread(fid,nums(3),'int32');
o4=fread(fid,'single');%diabazei mexri to telos
fclose(fid);
