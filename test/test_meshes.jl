using Meshes

# Produce a level set function that is a noisy version of the distance from
# the origin (such that level sets are noisy spheres).
#
# The noise should exercise marching tetrahedra's ability to produce a water-
# tight surface in all cases (unlike standard marching cubes).
#
N = 10
sigma = 1.0
distance = Float32[ sqrt(float32(i*i+j*j+k*k)) for i = -N:N, j = -N:N, k = -N:N ]
distance = distance + sigma*rand(2*N+1,2*N+1,2*N+1)

# Extract an isosurface.
#
lambda = N-2*sigma # isovalue

@time msh = isosurface(distance,lambda)

# Simplify the mesh
#
#msh2 = simplify(msh,0.1)

# Export the mesh to a ply.
#
# The mesh can be visualized, e.g., in MeshLab (http://meshlab.sourceforge.net/).
#   
exportToPly(msh,"noisy_sphere.ply")

# test contatenation
msh3 = merge(msh,msh)


function testUnionNotInterection()
	# creates Union, Not, Intersection of cube and sphere
	# 
	# http://en.wikipedia.org/wiki/Constructive_solid_geometry

	# volume of interest
	x_min, x_max = -1, 15
	y_min, y_max = -1, 5
	z_min, z_max = -1, 5
	scale = 8
	
	b1(x,y,z) = box(   x,y,z, 0,0,0,3,3,3)
	s1(x,y,z) = sphere(x,y,z, 3,3,3,sqrt(3))
	f1(x,y,z) = min(b1(x,y,z), s1(x,y,z))  # UNION
	b2(x,y,z) = box(   x,y,z, 5,0,0,8,3,3)
	s2(x,y,z) = sphere(x,y,z, 8,3,3,sqrt(3))
	f2(x,y,z) = max(b2(x,y,z), -s2(x,y,z)) # NOT
	b3(x,y,z) = box(   x,y,z, 10,0,0,13,3,3)
	s3(x,y,z) = sphere(x,y,z, 13,3,3,sqrt(3))
	f3(x,y,z) = max(b3(x,y,z), s3(x,y,z))  # INTERSECTION
	f(x,y,z) = min(f1(x,y,z), f2(x,y,z), f3(x,y,z))

	vol = volume(f, x_min,y_min,z_min,x_max,y_max,z_max, scale)
	msh = isosurface(vol, 0.0)
	exportToStl(msh, "wiki_csg.stl")
end
@time testUnionNotInterection()


function testCylinders()
	c1(x,y,z) = cylinderX(x,y,z, 0,0,1,-2,4)
	c2(x,y,z) = cylinderY(x,y,z, 0,0,1,-2,4)
	c3(x,y,z) = cylinderZ(x,y,z, 0,0,1,-2,4)
	f(x,y,z) = min(c1(x,y,z), c2(x,y,z), c3(x,y,z))

	vol = volume(f, -3,-3,-3, 5,5,5, 2)
	msh = isosurface(vol, 0.0)
	exportToStl(msh, "cylinders_test.stl")
end
@time testCylinders()
