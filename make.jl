import Pkg; Pkg.add("Documenter")
using Documenter, Peccon

makedocs(modules = [Peccon],
    doctest = true, 
    sitename="Peccon.jl", 
    format = Documenter.HTML(
        edit_link = "master",
        prettyurls = false)
    , 
    pages = Any[
        "Introduction" => "src/index.md", 
        "fundamental understanding" => "src/man/fundamental_understanding_intuition.md", 
        "theory" => "src/man/Theory.md", 
        "financial planning tools" => "src/man/financial_planning_tools.md",
        "API" => "src/lib/API.md"

    ])


    deploydocs(
        repo = "github.com/korilium/Peccon.jl.git",
    )