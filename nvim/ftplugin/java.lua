local jdtls = require("jdtls")
local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local config = {}
config.settings = {
	java = {
		signatureHelp = { enabled = true },
		contentProvider = { preferred = "fernflower" },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
			filteredTypes = {
				"com.sun.*",
				"io.micrometer.shaded.*",
				"java.awt.*",
				"jdk.*",
				"sun.*",
			},
		},
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			hashCodeEquals = {
				useJava7Objects = true,
			},
			useBlocks = true,
		},
		configuration = {
			runtimes = {
				{
					name = "JavaSE-1.8",
					path = "/usr/lib/jvm/java-8-openjdk/",
				},
				{
					name = "JavaSE-11",
					path = "/usr/lib/jvm/java-11-openjdk/",
				},
				{
					name = "JavaSE-16",
					path = home .. "/.local/jdks/jdk-16.0.1+9/",
				},
				{
					name = "JavaSE-17",
					path = home .. "/.local/jdks/jdk-17.0.2+8/",
				},
			},
		},
	},
}

config.cmd = {
	-- "/usr/lib/jvm/java-17-openjdk-17.0.6.0.10-1.fc37.x86_64/bin/java",
	"java",
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xmx4g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	-- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
	"-javaagent:" .. "/home/dmueller/.local/share/nvim/mason/packages/jdtls/lombok.jar",
	-- The jar file is located where jdtls was installed. This will need to be updated
	-- to the location where you installed jdtls
	"-jar",
	"/home/dmueller/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
	-- The configuration for jdtls is also placed where jdtls was installed. This will
	-- need to be updated depending on your environment
	"-configuration",
	"/home/dmueller/.local/share/nvim/mason/packages/jdtls/config_linux",

	-- Use the workspace_folder defined above to store data for this project
	"-data",
	workspace_folder,
}
config.on_attach = function(client, bufnr)
	require("me.lsp.conf").on_attach(client, bufnr, {
		server_side_fuzzy_completion = true,
	})

	-- jdtls.setup_dap({ hotcodereplace = "auto" })
	jdtls.setup.add_commands()
	local opts = { silent = true, buffer = bufnr }
	vim.keymap.set("n", "<A-o>", jdtls.organize_imports, opts)
	vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)
	vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts)
	-- vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
	-- vim.keymap.set("v", "crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
	-- vim.keymap.set("n", "crc", jdtls.extract_constant, opts)
	local create_command = vim.api.nvim_buf_create_user_command
	create_command(bufnr, "W", require("me.lsp.ext").remove_unused_imports, {
		nargs = 0,
	})
end

local jar_patterns = {
	"/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
	"/dev/dgileadi/vscode-java-decompiler/server/*.jar",
	"/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar",
	"/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar",
	"/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar",
	"/dev/testforstephen/vscode-pde/server/*.jar",
}
-- npm install broke for me: https://github.com/npm/cli/issues/2508
-- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
local plugin_path =
	"/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/"
local bundle_list = vim.tbl_map(function(x)
	return require("jdtls.path").join(plugin_path, x)
end, {
	"org.eclipse.jdt.junit4.runtime_*.jar",
	"org.eclipse.jdt.junit5.runtime_*.jar",
	"org.junit.jupiter.api*.jar",
	"org.junit.jupiter.engine*.jar",
	"org.junit.jupiter.migrationsupport*.jar",
	"org.junit.jupiter.params*.jar",
	"org.junit.vintage.engine*.jar",
	"org.opentest4j*.jar",
	"org.junit.platform.commons*.jar",
	"org.junit.platform.engine*.jar",
	"org.junit.platform.launcher*.jar",
	"org.junit.platform.runner*.jar",
	"org.junit.platform.suite.api*.jar",
	"org.apiguardian*.jar",
})
vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
	for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
		if
			not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
			and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
		then
			table.insert(bundles, bundle)
		end
	end
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
	bundles = bundles,
	extendedClientCapabilities = extendedClientCapabilities,
}
-- mute; having progress reports is enough
-- config.handlers["language/status"] = function() end
jdtls.start_or_attach(config)

--[[ local home = os.getenv('HOME')
	local root_markers = { "gradlew", "mvnw", ".git" }
	local root_dir = require("jdtls.setup").find_root(root_markers)
	local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
	local config = {
	flags = {
	debounce_text_changes = 80,
	},
	root_dir = root_dir, -- Set the root directory to our found root_marker
	-- Here you can configure eclipse.jdt.ls specific settings
	-- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
	java = {
	format = {
	settings = {
	-- Use Google Java style guidelines for formatting
	-- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
	-- and place it in the ~/.local/share/eclipse directory
	url = "/.local/share/eclipse/eclipse-java-google-style.xml",
	profile = "GoogleStyle",
	},
	},
	signatureHelp = { enabled = true },
	contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
	-- Specify any completion options
	completion = {
	favoriteStaticMembers = {
	"org.hamcrest.MatcherAssert.assertThat",
	"org.hamcrest.Matchers.*",
	"org.hamcrest.CoreMatchers.*",
	"org.junit.jupiter.api.Assertions.*",
	"java.util.Objects.requireNonNull",
	"java.util.Objects.requireNonNullElse",
	"org.mockito.Mockito.*",
	},
	filteredTypes = {
	"com.sun.*",
	"io.micrometer.shaded.*",
	"java.awt.*",
	"jdk.*",
	"sun.*",
	},
	},
	-- Specify any options for organizing imports
	sources = {
	organizeImports = {
	starThreshold = 9999,
	staticStarThreshold = 9999,
	},
	},
	-- How code generation should act
	codeGeneration = {
	toString = {
	template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
	},
	hashCodeEquals = {
	useJava7Objects = true,
	},
	useBlocks = true,
	},
	-- If you are developing in projects with different Java versions, you need
	-- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- And search for `interface RuntimeOption`
	-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
	configuration = {
	runtimes = {
	{
	name = "JDK-17",
	path = "/usr/lib/jvm/java-17-openjdk-17.0.6.0.10-1.fc37.x86_64",
	},
	{
	name = "JDK-11",
	path = "/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-1.fc37.x86_64",
	},
	{
	name = "JDK-1.8",
	path = "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.362.b09-2.fc37.x86_64",
	},
	},
	},
	},
	},
	-- cmd is the command that starts the language server. Whatever is placed
	-- here is what is passed to the command line to execute jdtls.
	-- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	-- for the full list of options
	cmd = {
	-- "/usr/lib/jvm/java-17-openjdk-17.0.6.0.10-1.fc37.x86_64/bin/java",
	"java",
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xmx2g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens", "java.base/java.util=ALL-UNNAMED",
	"--add-opens", "java.base/java.lang=ALL-UNNAMED",
	-- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
	"-javaagent:" .. "/home/dmueller/.local/share/nvim/mason/packages/jdtls/lombok.jar",
	-- The jar file is located where jdtls was installed. This will need to be updated
	-- to the location where you installed jdtls
	"-jar",	"/home/dmueller/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
	-- The configuration for jdtls is also placed where jdtls was installed. This will
	-- need to be updated depending on your environment
	"-configuration",
	"/home/dmueller/.local/share/nvim/mason/packages/jdtls/config_linux",

	-- Use the workspace_folder defined above to store data for this project
	"-data",
	workspace_folder,
	},
	}

	local M = {}
	function M.make_jdtls_config()
	return config
	end

	return M ]]
