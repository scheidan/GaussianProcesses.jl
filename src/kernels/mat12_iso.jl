# Matern 1/2 isotropic covariance Function

@doc """
# Description
Constructor for the isotropic Matern 1/2 kernel (covariance)

k(x,x') = σ²exp(-d/ℓ), where d=|x-x'|
# Arguments:
* `ll::Float64`: Log of the length scale ℓ
* `lσ::Float64`: Log of the signal standard deviation σ
""" ->
type Mat12Iso <: Kernel
    ll::Float64     #Log of length scale
    lσ::Float64     #Log of signal std
    Mat12Iso(ll::Float64, lσ::Float64) = new(ll,lσ)
end

function kern(mat::Mat12Iso, x::Vector{Float64},y::Vector{Float64})
    ell = exp(mat.ll)
    sigma2 = exp(2*mat.lσ)

    K = sigma2*exp(-norm(x-y)/ell)

    return K
end

get_params(mat::Mat12Iso) = exp(Float64[mat.ll, mat.lσ])

num_params(mat::Mat12Iso) = 2

function set_params!(mat::Mat12Iso, hyp::Vector{Float64})
    length(hyp) == 2 || throw(ArgumentError("Matern 1/2 covariance function only has two parameters"))
    mat.ll, mat.lσ = hyp
end

function grad_kern(mat::Mat12Iso, x::Vector{Float64}, y::Vector{Float64})
    ell = exp(mat.ll)
    sigma2 = exp(2*mat.lσ)

    dK_ell = sigma2*norm(x-y)/ell*exp(-norm(x-y)/ell)
    dK_sigma = 2.0*sigma2*exp(-norm(x-y)/ell)
    dK_theta = [dK_ell,dK_sigma]
    
    return dK_theta
end
