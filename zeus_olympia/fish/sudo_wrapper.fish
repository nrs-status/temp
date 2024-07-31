function sudo -d "sudo wrapper that handles aliases"
        if functions -q -- $argv[1] #checks if the first argument to sudo is a function. the -q option makes the `functions` command run quietly with no outputt
          set -l new_args (string join ' ' -- (string escape -- $argv)) #set -l defines a local variable which remains local to the function. in this case; the function "sudo". this line creates a new string from the arguments coming after the function passed to sudo
          set argv fish -c "$new_args" # this line modifies the argv array. in combination with the coming "command" command, it will dictate exactly what will be executed by the function
        end

        command sudo $argv # executes the command sudo along with the arguments passed
      end
