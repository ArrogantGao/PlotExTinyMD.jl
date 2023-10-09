function draw_init(trajectory, box::NTuple{6, T}, color, boundary_linewidth, boundary_color, markersize, transparency, hideaxis) where{T}
    Lxd, Lxu, Lyd, Lyu, Lzd, Lzu = box

    fig = Figure()
    ax = Axis3(fig[1, 1], aspect=:data)

    if hideaxis
        hidespines!(ax)
        hidedecorations!(ax)
    end

    vertices = [(Lxd, Lyd, Lzd), (Lxu, Lyd, Lzd), (Lxu, Lyu, Lzd), (Lxd, Lyu, Lzd), (Lxd, Lyd, Lzu), (Lxu, Lyd, Lzu), (Lxu, Lyu, Lzu), (Lxd, Lyu, Lzu)]
    edges = [(1, 2), (2, 3), (3, 4), (4, 1), (5, 6), (6, 7), (7, 8), (8, 5), (1, 5), (2, 6), (3, 7), (4, 8)]

    for e in edges
        lines!(ax, [vertices[e[1]][1], vertices[e[2]][1]], [vertices[e[1]][2], vertices[e[2]][2]], [vertices[e[1]][3], vertices[e[2]][3]], color=boundary_color, linewidth=boundary_linewidth)
    end

    position = Observable(Point3f[(data[3], data[4], data[5]) for data in trajectory[1]])
    color_array = [color[Int(data[2])] for data in trajectory[1]]
    scatter!(ax, position; color=color_array, markersize = markersize, transparency = transparency, markerspace=:data)

    return position, fig
end

function video_trajection(trajectory, box::NTuple{6, T}; filename::String = "trajectory.mp4", framerate::Int = 24, color::Vector = [:red, :blue, :green], boundary_linewidth=2.0,
    boundary_color=:black, markersize=0.05, transparency=true, hideaxis = true, save_result::Bool = true) where{T}

    position, fig = draw_init(trajectory, box, color, boundary_linewidth, boundary_color, markersize, transparency, hideaxis)

    step_iter = 1:1:length(trajectory)

    if save_result
        record(fig, filename, step_iter;
            framerate = framerate) do step
            trajectory_step = trajectory[step]
            position[] = Point3f[(data[3], data[4], data[5]) for data in trajectory_step]
        end
    end

    return true
end

function figure_trajection(trajectory, box::NTuple{6, T}, step::Int; filename::String = "state_$(step).png", color::Vector = [:red, :blue, :green], boundary_linewidth=2.0,
    boundary_color=:black, markersize=0.05, transparency=true, hideaxis = true, save_result::Bool = true) where{T}
    
    position, fig = draw_init(trajectory, box, color, boundary_linewidth, boundary_color, markersize, transparency, hideaxis)

    if save_result
        save(filename, fig)
    end
    
    return true
end