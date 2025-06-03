terraform { 
  cloud { 
    
    organization = "edion-reconstruct" 

    workspaces { 
      name = "edion-reconstruct-dev-04-app-web"
    } 
  } 
}