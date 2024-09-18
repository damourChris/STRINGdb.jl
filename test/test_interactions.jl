using Test
using ..STRINGdb

# Test the score function
@testset "score" begin
    interaction = Interaction("A", "B", "Protein A", "Protein B", 9606, 0.8, 0.7, 0.6, 0.5,
                              0.4, 0.3, 0.2, 0.1)
    @test score(interaction) == 0.8
end

# Test the species function
@testset "species" begin
    interaction = Interaction("A", "B", "Protein A", "Protein B", 9606, 0.8, 0.7, 0.6, 0.5,
                              0.4, 0.3, 0.2, 0.1)
    @test species(interaction) == 9606
end

# Test the identifiers function
@testset "identifiers" begin
    interaction = Interaction("A", "B", "Protein A", "Protein B", 9606, 0.8, 0.7, 0.6, 0.5,
                              0.4, 0.3, 0.2, 0.1)
    @test identifiers(interaction) == (proteinA="A", proteinB="B")
end

# Test the names function
@testset "names" begin
    interaction = Interaction("A", "B", "Protein A", "Protein B", 9606, 0.8, 0.7, 0.6, 0.5,
                              0.4, 0.3, 0.2, 0.1)
    @test names(interaction) == (proteinA="Protein A", proteinB="Protein B")
end

# Test the scores function
@testset "scores" begin
    interaction = Interaction("A", "B", "Protein A", "Protein B", 9606, 0.8, 0.7, 0.6, 0.5,
                              0.4, 0.3, 0.2, 0.1)
    @test scores(interaction) ==
          (combined=0.8, neighborhood=0.7, fusion=0.6, phylogenetic=0.5,
           coexpression=0.4, experimental=0.3, database=0.2, textmining=0.1)
end

# Test the get_interactions function
@testset "get_interactions" begin

    # Test with multiple identifiers
    @testset "multiple identifier" begin
        interactions = get_interactions(["CDC42", "KIF23"])
        @test length(interactions) == 2
        @test interactions[1].stringId_A == "9606.ENSP00000260363"
        @test interactions[1].stringId_B == "9606.ENSP00000383118"
        @test interactions[1].preferredName_A == "KIF23"
        @test interactions[1].preferredName_B == "CDC42"
        @test interactions[1].ncbiTaxonId == 9606
        @test interactions[1].score == 0.479
        @test interactions[1].nscore == 0.0
        @test interactions[1].fscore == 0.0
        @test interactions[1].pscore == 0.0
        @test interactions[1].ascore == 0.049
        @test interactions[1].escore == 0.086
        @test interactions[1].dscore == 0.0
        @test interactions[1].tscore == 0.449
    end
end