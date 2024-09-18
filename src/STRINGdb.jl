module STRINGdb
using JSON3

const BASE_URL = "https://version-11-5.string-db.org/api"

include("client.jl")
using .Client

include("interactions.jl")
using .InteractionTerms
export Interaction, score, scores, species, identifiers, names, get_interactions

end
