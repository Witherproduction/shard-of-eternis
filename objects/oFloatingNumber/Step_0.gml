x += vx;
y += vy;
vy *= 0.98;
life -= 1;
image_alpha = max(0, life / 50);
if (life <= 0) instance_destroy();
