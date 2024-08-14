module InteractionTerms

import ..STRINGdb: BASE_URL, Client

export Interaction, get_interactions

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

end