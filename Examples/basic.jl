using CartoonLike
points = create_circle(.4)
image, xLoc, yLoc = given_points(points, ninterp=100*100,ε=.001)
heatmap(xLoc, yLoc, image)


points = [-.5  -.9   0.0 .25   .5 .75;
          -.75 -.125 .9  .5  -.25 -.75]'
image, xLoc, yLoc = given_points(points, xSize=samples, ySize=samples)
heatmap(xLoc, yLoc, image')

