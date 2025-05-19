terraform { 
  cloud { 
    
    organization = "vti" 

    workspaces { 
      name = "edion-net-dev-02-shared" 
    } 
  } 
}