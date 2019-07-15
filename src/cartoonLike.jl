module cartoonLike

using Plots
using LinearAlgebra
using Interpolations
using NearestNeighbors

export create_circle, given_points
# still to make: piecewise smooth curves
#                fill in the interior, exterior with something smooth

"""
    create_circle(r, rate = 10)
create a circle of radius r, sampled at rate `rate`
"""
function create_circle(r, rate = 10)
    t = range(0,1,length = 10)
    x = r .* sin.(2π*t)
    y = r .* cos.(2π*t)
    A = hcat(x,y)
end


"""
    image, xlocs, ylocs = given_points(points; xSize=100, ySize=100, ninterp = xSize*ySize, ε = .01)

given a collection of nodes, i.e. row vectors of the form (x,y), make a
(xSize)×(ySize) image of path going through them, which has been blurred with a
gaussian of standard deviation of ε (\epsilon)
"""
function given_points(points; xSize=100, ySize=100, ninterp = xSize*ySize, ε =
                      1/(xSize*ySize)^(3/4))
    t= range(0, 1, length = size(points, 1))
    itp = scale(interpolate(points, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), t, 1:2)
    tfine = range(0, 1, length = ceil(Int, ninterp))
    finePoints = itp(tfine, 1:2)'
    tree = KDTree(Array{Float64,2}(finePoints))

    xRange = range(-1, 1, length=xSize)
    yRange = range(-1, 1, length=ySize)

    imagePoints = zeros(2, xSize, ySize)
    for (ix,x) =enumerate(xRange), (iy,y) = enumerate(yRange)
        imagePoints[1, ix, iy] = x
        imagePoints[2, ix, iy] = y
    end
    image = zeros(xSize, ySize)
    idxs, dists = knn(tree, reshape(imagePoints,(2,:)),1)
    dists = [d[1] for d in dists]       # the distances are given as lists, and we want
                                        # it as just an array
    dists = reshape(dists, size(image))
    image = exp.(-(dists).^2 ./ε)
    return (image, xRange, yRange)
end
end

points = create_circle(.4)
image, xLoc, yLoc = given_points(points, ninterp=100*100,ε=.001)
heatmap(xLoc, yLoc, image)


points = [-.5  -.9   0.0 .25   .5 .75;
          -.75 -.125 .9  .5  -.25 -.75]'
image, xLoc, yLoc = given_points(points, xSize=samples, ySize=samples)
heatmap(xLoc, yLoc, image')

