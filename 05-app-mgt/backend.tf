terraform { 
  cloud { 
    
    organization = "vti" 

    workspaces { 
      name = "edion-net-dev-05-app-mgt" 
    } 
  } 
}