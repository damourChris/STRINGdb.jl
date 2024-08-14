module InteractionTerms

import ..STRINGdb: BASE_URL, Client

export Interaction, score, scores, identifiers, names, get_interactions

@kwdef struct Interaction
    stringId_A::AbstractString
    stringId_B::AbstractString
    preferredName_A::AbstractString
    preferredName_B::AbstractString
    ncbiTaxonId::Any
    score::Float64
    nscore::Float64
    fscore::Float64
    pscore::Float64
    ascore::Float64
    escore::Float64
    dscore::Float64
    tscore::Float64
end

score(x::Interaction)::Float64 = x.score
species(x::Interaction)::AbstractString = x.ncbiTaxonID
identifiers(x::Interaction)::@NamedTuple{proteinA::AbstractString,proteinB::AbstractString} = (proteinA=x.stringId_A,
                                                                                               proteinB=x.stringId_B)
names(x::Interaction)::@NamedTuple{proteinA::AbstractString,proteinB::AbstractString} = (proteinA=x.preferredName_A,
                                                                                         proteinB=x.preferredName_B)
function scores(x::Interaction)::@NamedTuple{combined::Float64,neighborhood::Float64,
                                             fusion::Float64,phylogenetic::Float64,
                                             coexpression::Float64,experimental::Float64,
                                             database::Float64,textmining::Float64}
    return (combined=x.score, neighborhood=x.nscore, fusion=x.fscore,
            phylogenetic=x.pscore,
            coexpression=x.ascore, experimental=x.escore, database=x.dscore,
            textmining=x.tscore)
end

"""
    get_interactions(identifiers::Vector{String};
                     required_score::Float64=750,
                     network_type::String="default",
                     show_query_node_labels::Bool=false,
                     add_nodes::Bool=false,
                     species::AbstractString="9606")::Vector{Interaction}

Get interaction partners for the given list of protein identifiers.

# Arguments
- `identifiers::Vector{String}`: A vector of protein identifiers.
- `required_score::Float64`: The minimum required score for the interaction. A number between 0 and 1000. Default is 750.
- `network_type::Symbol`: The type of network to use. Either 'functional' or 'physical'. Default is 'functional'.
- `show_query_node_labels::Bool`: Whether to show the query node labels. Default is false.
- `add_nodes::Bool`: When available, use submitted names in the preferredName column. Default is false.
- `species::AbstractString`: The NCBI Taxon ID for the species. Default is "9606" which is the human species.

"""
function get_interactions(identifiers::Vector{String};
                          required_score::Float64=750,
                          network_type::Symbol=:functional,
                          show_query_node_labels::Bool=false,
                          add_nodes::Bool=false,
                          species::AbstractString="9606")::Vector{Interaction}
    if required_score < 0 || required_score > 1000
        throw(ArgumentError("required_score must be between 0 and 1000"))
    end

    if network_type != :functional && network_type != :physical
        throw(ArgumentError("network_type must be either 'functional' or 'physical'"))
    end

    url = BASE_URL * "/json/" * "/network"

    q = Dict("identifiers" => join(identifiers, "%0d"),
             "required_score" => required_score,
             "network_type" => String(network_type),
             "show_query_node_labels" => show_query_node_labels,
             "add_nodes" => add_nodes,
             "species" => species)
    q = filter(x -> x[2] != "" && x[2] != false, q)

    data = try
        response = Client.get(url; query=q)
        # return String(response.body)
        body = JSON3.read(String(response.body), Vector{Dict})

        interaction_terms = [Interaction(x["stringId_A"],
                                         x["stringId_B"],
                                         x["preferredName_A"],
                                         x["preferredName_B"],
                                         x["ncbiTaxonId"],
                                         x["score"],
                                         x["nscore"],
                                         x["fscore"],
                                         x["pscore"],
                                         x["ascore"],
                                         x["escore"],
                                         x["dscore"],
                                         x["tscore"]) for x in body]

        return interaction_terms
    catch e
        @error e
        @warn "Error fetching interaction partners. Returning missing."
        return missing
    end
end

end