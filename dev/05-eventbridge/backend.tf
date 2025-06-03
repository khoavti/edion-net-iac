terraform { 
  cloud { 
    
    organization = "edion-reconstruct" 

    workspaces { 
      name = "edion-reconstruct-dev-05-eventbridge"
    } 
  } 
}