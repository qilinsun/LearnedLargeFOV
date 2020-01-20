function nonuniform_blur_GT_fitted = uniformFit(nonuniform_blur_GT)
ch1_in = nonuniform_blur_GT(:,:,1);
ch2_in = nonuniform_blur_GT(:,:,2);
ch3_in = nonuniform_blur_GT(:,:,3);

x=1:size(ch1_in,2);
y=1:size(ch1_in,1);
[xx,yy]=meshgrid(x,y);

ch1_surf=fit([xx(:),yy(:)],ch1_in(:),'poly55');
ch1_out=ch1_surf(xx(:),yy(:));
ch1_out=reshape(ch1_out,size(ch1_in));
% mesh(ch1_in-ch1_out);
ch2_surf=fit([xx(:),yy(:)],ch2_in(:),'poly55');
ch2_out=ch2_surf(xx(:),yy(:));
ch2_out=reshape(ch2_out,size(ch1_in));

ch3_surf=fit([xx(:),yy(:)],ch3_in(:),'poly55');
ch3_out=ch3_surf(xx(:),yy(:));
ch3_out=reshape(ch3_out,size(ch1_in));

nonuniform_blur_GT_fitted=zeros(size(nonuniform_blur_GT));
nonuniform_blur_GT_fitted(:,:,1)=ch1_out./255;
nonuniform_blur_GT_fitted(:,:,2)=ch2_out./255;
nonuniform_blur_GT_fitted(:,:,3)=ch3_out./255;
