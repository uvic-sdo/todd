task :revert => :revert_db do
  if agree("This will remove the .todd file in the local dir.  Continue?")
    rm '.todd'
  end
end
