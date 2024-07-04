using STRINGdb
using Documenter

DocMeta.setdocmeta!(STRINGdb, :DocTestSetup, :(using STRINGdb); recursive=true)

makedocs(;
    modules=[STRINGdb],
    authors="Chris Damour",
    sitename="STRINGdb.jl",
    format=Documenter.HTML(;
        canonical="https://damourChris.github.io/STRINGdb.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/damourChris/STRINGdb.jl",
    devbranch="main",
)
