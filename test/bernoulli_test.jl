using SpecialFunctions
using Base.Test

const SF = SpecialFunctions

@testset "Bernoulli polynomials and numbers" begin
    @testset "    consistency" begin
        for i=0:34
            @test Float64(SF.bernoulli(i)) ≈ SF.bernoulli(i, 0.0)
        end
    end
    
    @testset "    numbers explicit cases" begin
        for i=2:34
            # first two values of zeta don't work
            @test Float64(SF.bernoulli(i)) ≈ -i*SF.zeta( 1 - i )
        end
    end 
    
    @testset "    polynomials explicit cases" begin
        X = collect(-2.0 : 0.1 : 3.0)
        for i=1:length(X)
            x = X[i]
            # println("   x = $x")
            @test SF.bernoulli(0, x) ≈ 1.0
            @test SF.bernoulli(1, x) ≈ x   - 0.5
            @test SF.bernoulli(2, x) ≈ x^2 -     x   + 1.0/6.0
            @test SF.bernoulli(3, x) ≈ x^3 - 1.5*x^2 + 0.5*x
            @test SF.bernoulli(4, x) ≈ x^4 - 2.0*x^3 +     x^2 - 1/30.0
            @test SF.bernoulli(5, x) ≈ x^5 - 2.5*x^4 + (5.0/3.0)*x^3 - x/6.0
            @test SF.bernoulli(6, x) ≈ x^6 - 3.0*x^5 + (5.0/2.0)*x^4 - 0.5*x^2 + 1/42.0
        end
    end
    
    @testset "    symmetries" begin
        X = collect(0.0: 0.1 : 1.0)
        for i=1:length(X)
            x = X[i]
            for n=1:9
                # println("   n = $n, x = $x")
                # start to get errors of order 1.0e-14 for n=5, 1.0e-13 around n=10, ...
                @test abs( SF.bernoulli(n, 1-x) - (-1.0)^n * SF.bernoulli(n, x) ) < 1.0e-13
                @test abs( SF.bernoulli(n, x+1) - SF.bernoulli(n, x) - n*x^(n-1) )  < 1.0e-13
                @test abs( (-1)^n * SF.bernoulli(n, -x) -  SF.bernoulli(n, x) - n*x^(n-1) ) < 1.0e-13

                # Raabe (1851)
                m = 6.0
                k = 0:m-1
                @test abs(  sum( SF.bernoulli.(n, x + k/m ) )/m - m^(-n)*SF.bernoulli(n, m*x )  ) < 1.0e-13
                
            end
        end
    end
end
