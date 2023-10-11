module PlotExTinyMD

using ExTinyMD, GLMakie

export load_lammpstrj
export video_trajection, figure_trajection

include("draw_trajection.jl")
include("load_lammps.jl")

end
