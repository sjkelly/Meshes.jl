using ImmutableArrays

typealias Vertex Vector3{Float64}

immutable Face
    v1 :: Int64
    v2 :: Int64
    v3 :: Int64
end

abstract AbstractMesh

type Mesh <: AbstractMesh
    vertices :: Vector{Vertex}
    faces :: Vector{Face}
end

vertices(m::Mesh) = m.vertices
faces(m::Mesh) = m.faces

# concatenates two meshes
function merge(m1::AbstractMesh, m2::AbstractMesh)
    v1 = vertices(m1)
    f1 = faces(m1)
    v2 = vertices(m2)
    f2 = faces(m2)
    nV = size(v1,1)
    nF = size(f2,1)
    newF2 = Face[ Face(f2[i].v1+nV, f2[i].v2+nV, f2[i].v3+nV) for i = 1:nF ]
    Mesh(append!(v1,v2),append!(f1,newF2))
end

export Vertex, Face, AbstrctMesh, Mesh, vertices, faces, merge
