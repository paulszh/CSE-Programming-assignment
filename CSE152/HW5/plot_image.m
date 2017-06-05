function plot_image(orig_image, U,mu)
    
pc_score = U' * orig_image; %here orig_image has already be subtracted by a mean vector

figure
subplot(2,5,1)
axis off
U1 = reconstruct_image(U,1,mu,pc_score);
imagesc(U1)
axis off
subplot(2,5,2)
U2 = reconstruct_image(U,2,mu,pc_score);
imagesc(U2)
axis off
subplot(2,5,3)
U3 = reconstruct_image(U,3,mu,pc_score);
imagesc(U3)
axis off
subplot(2,5,4)
U4 = reconstruct_image(U,4,mu,pc_score);
imagesc(U4)
axis off
subplot(2,5,5)
U5 = reconstruct_image(U,5,mu,pc_score);
imagesc(U5)
axis off
subplot(2,5,6)
U6 = reconstruct_image(U,6,mu,pc_score);
imagesc(U6)
axis off
subplot(2,5,7)
U7 = reconstruct_image(U,7,mu,pc_score);
imagesc(U7)
axis off
subplot(2,5,8)
U8 = reconstruct_image(U,8,mu,pc_score);
imagesc(U8)
axis off
subplot(2,5,9)
U9 = reconstruct_image(U,9,mu,pc_score);
imagesc(U9)
axis off
subplot(2,5,10)
U10 = reconstruct_image(U,10,mu,pc_score);
imagesc(U10)
axis off
colormap gray


end