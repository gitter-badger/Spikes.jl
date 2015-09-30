
export fit!, validate!

#=
Maximum Liklihood

Linear Discriminant Analysis
Quadratic Discriminant Analysis
Diagonal Discriminant Analysis
Diagonal Quadratic Discriminant Analysis
Shrinkage?
=#

#=
LDA
=#

function fit!{C<:LDA, V<:validation}(m::decoder{C,V})

    classes=unique(m.stimulus)
    k=length(classes)

    nGroup=zeros(Int64,k)
    GroupMean=zeros(Float64,k,size(m.response,2))
    Sw=zeros(Float64,size(m.response,2),size(m.response,2))
    m.c.W=zeros(Float64,k,size(m.response,2)+1)

    for i=1:k
        Group = m.stimulus.==classes[i]
        nGroup[i]=sum(Group)

        GroupMean[i,:]=mean(m.response[Group,:],1)

        Sw += cov(m.response[Group,:])
        
    end

    Sw=Sw./k
    St=cov(m.response)
    Sb = St - Sw

    (myv, m.c.W)=eig(Sb,Sw)
    
    m.c.centroids=GroupMean*m.c.W

    nothing
    
end

function validate!{C<:LDA, V<:Training}(m::decoder{C,V})

    classes=unique(m.stimulus)
    m.predict=zeros(Float64,size(m.v.stimulus,1))

    xnew=m.v.response*m.c.W

    mydist=zeros(Float64,length(classes))
    
    for i=1:size(m.v.stimulus,1)
        for j=1:length(classes)
            mydist[j]=norm(xnew[i,:]-m.c.centroids[j,:])
        end
        m.predict[i]=classes[indmin(mydist)]
    end

    nothing
    
end

#=
Nearest Neighbor Classification

Quian Quiroga et al 2006
=#

#=
Naive Bayesian
=#
