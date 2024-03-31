local M = {}

function M.prompt_architecture_and_feature()
	local architecture_choice = vim.fn.input("Choose architecture (b for BLoC/c for Cubit): ")
	local chosen_architecture
	if architecture_choice:lower() == "b" then
		chosen_architecture = "BLoC"
	elseif architecture_choice:lower() == "c" then
		chosen_architecture = "Cubit"
	else
		print("Invalid choice")
		return
	end
	print("You chose: " .. chosen_architecture)

	local feature_name = vim.fn.input("Enter feature name (without .dart): ")
	local base_path = vim.fn.getcwd()

	M.generate_files(base_path, feature_name, chosen_architecture)
end

function M.generate_files(base_path, feature_name, architecture_choice)
	local feature_base_path = base_path
		.. (string.match(base_path, "/lib$") and "/features" or "/lib/features")
		.. "/"
		.. feature_name
	os.execute("mkdir -p " .. feature_base_path)

	local camelCaseFeatureName = M.to_camel_case(feature_name)

	local directories = {
		"data/datasources",
		"data/models",
		"data/repositories",
		"domain/entities",
		"domain/usecases",
		"domain/repository_impl",
		"presentation/screens",
		"presentation/widgets",
		"presentation/" .. (architecture_choice == "BLoC" and "blocs" or "cubits"),
	}

	local export_files_content = {
		data = {},
		domain = {},
		presentation = {},
	}

	for _, dir in ipairs(directories) do
		local dir_path = feature_base_path .. "/" .. dir
		os.execute("mkdir -p " .. dir_path)

		if architecture_choice == "BLoC" and dir:match("blocs") then
			M.create_bloc_files(dir_path, feature_name, camelCaseFeatureName, export_files_content.presentation)
		elseif architecture_choice == "Cubit" and dir:match("cubits") then
			M.create_cubit_files(dir_path, feature_name, camelCaseFeatureName, export_files_content.presentation)
		else
			local file_base_name = feature_name .. "_" .. dir:match("[^/]+$")
			local file_path = dir_path .. "/" .. file_base_name .. ".dart"
			local file_content = "// Placeholder for " .. file_base_name .. ".dart --\n"
			M.create_file(file_path, file_content)

			local relative_path = "../" .. dir:gsub(".*/", "") .. "/" .. file_base_name .. ".dart"
			table.insert(export_files_content[dir:match("([^/]+)/*")], relative_path)
		end
	end

	M.create_export_files(feature_base_path, export_files_content)

	print("Feature " .. feature_name .. " setup for " .. architecture_choice .. " architecture has been completed.")
end

function M.create_bloc_files(dir_path, feature_name, camelCaseFeatureName, export_list)
	local bloc_file_path = dir_path .. "/" .. feature_name .. "_bloc.dart"
	local bloc_file_content = [[
import 'package:flutter_bloc/flutter_bloc.dart';
part ']] .. feature_name .. [[_event.dart';
part ']] .. feature_name .. [[_state.dart';

class ]] .. camelCaseFeatureName .. [[Bloc extends Bloc<]] .. camelCaseFeatureName .. [[Event, ]] .. camelCaseFeatureName .. [[State> {
  ]] .. camelCaseFeatureName .. [[Bloc() : super(]] .. camelCaseFeatureName .. [[Initial());
}
]]
	M.create_file(bloc_file_path, bloc_file_content)
	table.insert(export_list, bloc_file_path:match("presentation/blocs/(.*)"))

	local event_file_path = dir_path .. "/" .. feature_name .. "_event.dart"
	local event_file_content = [[
part of ']] .. feature_name .. [[_bloc.dart';

abstract class ]] .. camelCaseFeatureName .. [[Event extends Equatable {
  const ]] .. camelCaseFeatureName .. [[Event();
}
]]
	M.create_file(event_file_path, event_file_content)

	local state_file_path = dir_path .. "/" .. feature_name .. "_state.dart"
	local state_file_content = [[
part of ']] .. feature_name .. [[_bloc.dart';

abstract class ]] .. camelCaseFeatureName .. [[State extends Equatable {
  const ]] .. camelCaseFeatureName .. [[State();
}
]]
	M.create_file(state_file_path, state_file_content)
end

function M.create_cubit_files(dir_path, feature_name, camelCaseFeatureName, export_list)
	local cubit_file_path = dir_path .. "/" .. feature_name .. "_cubit.dart"
	local cubit_file_content = [[
import 'package:flutter_bloc/flutter_bloc.dart';
part ']] .. feature_name .. [[_state.dart';

class ]] .. camelCaseFeatureName .. [[Cubit extends Cubit<]] .. camelCaseFeatureName .. [[State> {
  ]] .. camelCaseFeatureName .. [[Cubit() : super(]] .. camelCaseFeatureName .. [[Initial()]);
}
]]
	M.create_file(cubit_file_path, cubit_file_content)
	table.insert(export_list, cubit_file_path:match("presentation/cubits/(.*)"))

	local state_file_path = dir_path .. "/" .. feature_name .. "_state.dart"
	local state_file_content = [[
part of ']] .. feature_name .. [[_cubit.dart';

class ]] .. camelCaseFeatureName .. [[State extends Equatable {
  const ]] .. camelCaseFeatureName .. [[State();
}
]]
	M.create_file(state_file_path, state_file_content)
end

function M.create_export_files(feature_base_path, export_files_content)
	for main_dir, files in pairs(export_files_content) do
		local export_file_path = feature_base_path .. "/" .. main_dir .. "/" .. main_dir .. "_exports.dart"
		local export_file_content = "export '" .. table.concat(files, "';\nexport '") .. "';\n"
		M.create_file(export_file_path, export_file_content)
	end
end

function M.create_file(file_path, content)
	local file = io.open(file_path, "w")
	if file then
		file:write(content)
		file:close()
	else
		print("Failed to create file: " .. file_path)
	end
end

function M.to_camel_case(str)
	return str:gsub("(%l)(%w*)", function(a, b)
		return string.upper(a) .. b
	end)
end

return M
