terraform { 
  cloud { 
    
    organization = "edion-reconstruct" 

    workspaces { 
      name = "edion-reconstruct-dev-03-app-platform"
    } 
  } 
}