function load_lammpstrj(filename::String)
    file = open(filename, "r")

    timestep = Vector{Int64}()
    num_atoms = 0
    box_bounds = [[0.0, 0.0] for i in 1:3]
    trajectory = Vector{Vector{Tuple{Int, Int, Float64, Float64, Float64}}}()

    for line in eachline(file)
        if line == "ITEM: TIMESTEP"
            push!(timestep, parse(Int, readline(file)))
        elseif line == "ITEM: NUMBER OF ATOMS"
            num_atoms = parse(Int, readline(file))
        elseif line == "ITEM: BOX BOUNDS pp pp ff"
            for i in 1:3
                bounds = split(readline(file))
                box_bounds[i] = [parse(Float64, bounds[1]), parse(Float64, bounds[2])]
            end
        elseif line == "ITEM: ATOMS id type x y z "
            data_step = Vector{Tuple{Int, Int, Float64, Float64, Float64}}()
            for _ in 1:num_atoms
                atom_line = readline(file)
                d = split(atom_line)
                atom_data = (parse(Int, d[1]), parse(Int, d[2]), parse(Float64, d[3]), parse(Float64, d[4]), parse(Float64, d[5]))
                push!(data_step, atom_data)
            end
            push!(trajectory, data_step)
        end
    end

    close(file)

    box = (box_bounds[1][1], box_bounds[1][2], box_bounds[2][1], box_bounds[2][2], box_bounds[3][1], box_bounds[3][2])

    return trajectory, box, timestep, num_atoms
end