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
        "setup" => "index.md", 
        "fundamental understanding" => "man/fundamental_understanding_intuition.md", 
        "glossary" => "man/glossary.md",
        "theory" => "man/Theory.md", 
        "financial planning tools" => "man/financial_planning_tools.md",
        "API" => "lib/API.md"

    ])

    deploydocs(
    repo = "github.com/korilium/Peccon.jl.git",
)