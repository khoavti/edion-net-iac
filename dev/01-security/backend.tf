terraform { 
  cloud { 
    
    organization = "edion-reconstruct" 

    workspaces { 
      name = "edion-reconstruct-dev-01-security" 
    } 
  } 
}