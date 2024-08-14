module STRINGdb
using DataFrames
using JSON3

const BASE_URL = "https://version-11-5.string-db.org/api"

include("client.jl")
using .Client

include("interactions.jl")
using .InteractionTerms
export Interaction, score, scores, identifiers, names, get_interactions

end
