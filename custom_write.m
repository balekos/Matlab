function custom_write (d1,d2,d3,d4,filename)
fid=fopen(filename,'w+');
if fid<0
    fprintf('error opening the file %s \n',filename);
    return;
end
n1=length(d1(:));
n2=length(d2(:));
n3=length(d3(:));
fwrite(fid,[n1,n2,n3],'int16');
fwrite(fid,d1,'char');
fwrite(fid,d2,'single');
fwrite(fid,d3,'int32');
fwrite(fid,d4,'single');
fclose(fid);
