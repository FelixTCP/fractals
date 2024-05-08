pointx=-0.74505999041908
pointy=0.11841400209530

rad=2
N=100

w=1024
h=1024
max_iter=2000

for i in $(seq 1 $N) ; do
	rad=$(echo "$rad*0.96" | bc -l) 
	xmin=$(echo "$pointx-$rad"|bc -l)
	xmax=$(echo "$pointx+$rad"|bc -l)
	ymin=$(echo "$pointy-$rad"|bc -l)
	ymax=$(echo "$pointy+$rad"|bc -l)
    #echo $i/$N: 
    ./mandelcuda_i $w $h $(printf "./out/anim-%04d.png" $i) $xmin $xmax $ymin $ymax $max_iter
done

#ffmpeg -r 30 -f image2 -s ${w}x$h -i ./out/anim-%04d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p mandelbrot_i.mp4
