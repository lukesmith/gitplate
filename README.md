Gitplate is a templating solution using git repositories.

Do you often create new projects and have a common repository structure you like to use, with a set of basic build
scripts? Gitplate aims to make it quick and simple to get a new project up and running. Point gitplate at any git
repository to have a new project created in its image. Gitplate will also run a 'plate' file on the new
repository. This plate file can contain tasks to rename files as well as any extra actions you require.

#### Installation:
    gem install gitplate


#### Example usage
    gitplate myproject git://github.com/lukesmith/RepositoryTemplate


#### Example plate file:
    init do
      rename 'SampleSolution.sln', "#{project_name}.sln"
      rename 'SampleSolution.build.bat', "#{project_name}.build.bat"
      rename 'SampleSolution.package.bat', "#{project_name}.package.bat"
    end

    custom_task :dosomething do
      # call via 'gitplate custom dosomething'
    end