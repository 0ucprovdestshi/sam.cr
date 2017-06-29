require "./spec_helper"

describe Sam do
  describe "::namespace" do
  end

  describe "::task" do
  end

  describe "::invoke" do
    it "raises error if given task is not exists" do
      expect_raises(Exception, "Task giberrish was not found") do
        Sam.invoke("giberrish")
      end
    end
  end

  describe "::find" do
    it "finds correct task by path" do
      Sam.find!("db:schema:load").name.should eq("load")
    end
  end

  describe "::help" do
  end

  describe ".generate_makefile" do
    desclaration_part = <<-FILE
          # === Sam shortcut
          # next lines are autogenerated and any changes will be discarded after regenerating
          CRYSTAL_BIN ?= `which crystal`
          SAM_PATH ?= "src/sam.cr"
          .PHONY: sam
          sam:
          \t$(CRYSTAL_BIN) run $(SAM_PATH) -- $(filter-out $@,$(MAKECMDGOALS))
          # === Sam shortcut\n
          FILE
    makefile = "../Makefile"

    it "creates new makefile" do
      begin
        File.exists?(makefile).should eq(false)
        Sam.generate_makefile("src/sam.cr")
        File.read(makefile).should eq(desclaration_part)
      ensure
        File.delete(makefile) if File.exists?(makefile)
      end
    end

    it "correctly regenerates existing file" do
      begin
        File.exists?(makefile).should eq(false)
        File.write(makefile, "# before\n" + desclaration_part + "# after\n")
        Sam.generate_makefile("src/sam.cr")
        File.read(makefile).should eq("# before\n# after\n" + desclaration_part)
      ensure
        File.delete(makefile) if File.exists?(makefile)
      end
    end
  end

  describe "%load_dependencies" do
    it "properly loads tasks from dependencies" do
      Sam.find!("din:dong")
    end
  end

  it "includes all default tasks" do
    Sam.find!("help")
    Sam.find!("generate:makefile")
  end
end
