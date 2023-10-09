using ExTinyMD, PlotExTinyMD

begin
    n_atoms = 100
    n_atoms = Int64(round(n_atoms))
    L = 50.0
    boundary = CubicBoundary(L)
    atoms = Vector{Atom{Float64}}()

    for i in 1:n_atoms
        push!(atoms, Atom(type = rand(1:2), mass = 1.0, charge = 0.0))
    end

    info = SimulationInfo(n_atoms, atoms, (0.0, L, 0.0, L, 0.0, L), boundary; min_r = 0.1, temp = 1.0)

    interactions = [(LennardJones(), CellList3D(info, 4.5, boundary, 100))]
    loggers = [TempartureLogger(100, output = false), TrajectionLogger(step = 100, output = true)]
    simulator = VerletProcess(dt = 0.001, thermostat = AndersenThermoStat(1.0, 0.05))

    sys = MDSys(
        n_atoms = n_atoms,
        atoms = atoms,
        boundary = boundary,
        interactions = interactions,
        loggers = loggers,
        simulator = simulator
    )

    simulate!(simulator, sys, info, 10000)

    data = load_trajection("/trajectory.txt")
    box = (0.0, 10.0, 0.0, 10.0, 0.0, 10.0)
    video_trajection(data, box)
    figure_trajection(data, box, 100)
end