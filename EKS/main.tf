provider "aws" {
    region = "ap-south-1"
    # profile = "eks"
    
} 
module "nw" {
source = "./modules/vpc"
vpccidr = "10.0.0.0/20"
pub-subnet={
        pub_sub-1 = {
         pub-az   = "ap-south-1a"
         pub-cidr = "10.0.0.0/22"
},
         pub_sub-2  = {
         pub-az     = "ap-south-1b"
         pub-cidr   = "10.0.4.0/22"
        }
} 
pvt-subnet={
        pvt_sub-1  = {
         pvt-az    = "ap-south-1a"
         pvt-cidr  = "10.0.8.0/22"
},
         pvt_sub-2 = {
         pvt-az    = "ap-south-1b"
         pvt-cidr  = "10.0.12.0/22"
        }
}        

env = "dev"
}
module "sg" {
    source = "./modules/sg"
   sg_details = {
    eks-sg ={
        name   ="eks"
        description = "olny ssh incoming"
        vpc_id = module.nw.dev-vpc-id
        ingress_rules =[

            {
                from_port    = "22"
                to_port      = "22"
                protocol     = "tcp"
                cidr_blocks  = null
                self         = true
            },

        ]
    },
    
    }
}
    
module "iam_role" {
    source = "./modules/iam"
}

module "eks" {
  source = "./modules/eks"
snet = {
    snet1 = {
       snet-id = lookup(module.nw.pub-snet-id,"pub_sub-1",null).id 
       
   },
       snet2 = {
        snet-id = lookup(module.nw.pub-snet-id,"pub_sub-2",null).id
    }
}

role = module.iam_role.role-arn
node-role = module.iam_role.workernode-role-arn
eks_sg = lookup(module.sg.dev-sg-id,"eks-sg",null)
}