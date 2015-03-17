-record(stock, {
					id,
					active,
					name,
					description,
					type,
					cost = #cost{},
					influence_generated,
					control_generated,
					next_generation,
					prev_generation,
					art,
					specials = [],
					theme,
					story,
					powers = [],
					affiliation = [],
					span = 1,
					required_spheres = [],
					forbidden_spheres = []
				 }).
