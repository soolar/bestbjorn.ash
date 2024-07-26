script "bestbjorn.ash";
notify "soolar the second";

record bjorn_data
{
	familiar fam;
	item [int] drops;
	float dropChance;
	boolean limited;
};

bjorn_data [int] get_bjorn_data(boolean includeUnowned)
{
	bjorn_data [int] res;

	void add_entry(familiar fam, boolean [item] drops, float dropChance, boolean limited)
	{
		if(!have_familiar(fam) && !includeUnowned)
		{
			return;
		}

		bjorn_data entry;
		entry.fam = fam;
		foreach it in drops
		{
			entry.drops[entry.drops.count()] = it;
		}
		entry.dropChance = dropChance;
		entry.limited = limited;
		res[res.count()] = entry;
	}

	void add_entry(familiar fam, boolean [item] drops, float dropChance)
	{
		add_entry(fam, drops, dropChance, false);
	}

	add_entry($familiar[angry goat], $items[goat cheese pizza], 1);
	add_entry($familiar[cocoabo], $items[white chocolate chips], 1);
	add_entry($familiar[crimbo elf], $items[candy cane, cold hots candy, wint-o-fresh mint], 1);
	add_entry($familiar[flaming gravy fairy], $items[hot nuggets], 1);
	add_entry($familiar[frozen gravy fairy], $items[cold nuggets], 1);
	add_entry($familiar[stinky gravy fairy], $items[stench nuggets], 1);
	add_entry($familiar[spooky gravy fairy], $items[spooky nuggets], 1);
	add_entry($familiar[attention-deficit demon], $items[chorizo brownies, white chocolate and tomato pizza, carob chunk noodles], 1);
	add_entry($familiar[sweet nutcracker], $items[candy cane, eggnog, fruitcake, gingerbread bugbear], 1);
	add_entry($familiar[sleazy gravy fairy], $items[sleaze nuggets], 1);
	add_entry($familiar[astral badger], $items[spooky mushroom, knob mushroom, knoll mushroom], 2);
	add_entry($familiar[ancient yuletide troll], $items[candy cane, eggnog, fruitcake, gingerbread bugbear], 1);
	add_entry($familiar[green pixie], $items[bottle of tequila], 1);
	add_entry($familiar[gluttonous green ghost], $items[bean burrito, enchanted bean burrito, jumping bean burrito], 1);
	// hunchbacked minion based on a guess by bmaher
	add_entry($familiar[hunchbacked minion], $items[skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, skeleton bone, disembodied brain], 1);
	add_entry($familiar[untamed turtle], $items[snailmail bits, turtlemail bits, turtle wax], 1);
	add_entry($familiar[cotton candy carnie], $items[cotton candy pinch], 1);
	add_entry($familiar[stocking mimic], $items[angry farmer candy, cold hots candy, rock pops, tasty fun good rice candy, wint-o-fresh mint], 1);
	add_entry($familiar[bricko chick], $items[bricko brick], 1);
	add_entry($familiar[pottery barn owl], $items[volcanic ash], 0.1);
	add_entry($familiar[piano cat], $items[beertini, papaya slung, salty slug, tomato daiquiri], 1);
	add_entry($familiar[robot reindeer], $items[candy cane, eggnog, fruitcake, gingerbread bugbear], 1);
	add_entry($familiar[li\'l xenomorph], $items[lunar isotope], 1.0 / 17.0);
	add_entry($familiar[reanimated reanimator], $items[broken skull, broken skull, broken skull, broken skull, hot wing], 1);
	add_entry($familiar[warbear drone], $items[warbear whosit], 1.0 / 4.5);
	add_entry($familiar[golden monkey], $items[gold nuggets], 0.5);
	add_entry($familiar[mini kiwi], $items[mini kiwi], 0.08);

	void limited_add_entry(familiar fam, boolean [item] drops, float dropChance, string prop, int limit)
	{
		if(get_property(prop).to_int() < limit)
		{
			add_entry(fam, drops, dropChance, true);
		}
	}

	limited_add_entry($familiar[machine elf], $items[abstraction: sensation, abstraction: thought, abstraction: action, abstraction: category, abstraction: perception, abstraction: purpose], 0.2, "_abstractionDropsCrown", 25);
	limited_add_entry($familiar[garbage fire], $items[burning newspaper], 3 - get_property("_garbageFireDropsCrown").to_int(), "_garbageFireDropsCrown", 3);
	limited_add_entry($familiar[grim brother], $items[grim fairy tale], 1, "_grimFairyTaleDropsCrown", 2);
	limited_add_entry($familiar[grimstone golem], $items[grimstone mask], 1, "_grimstoneMaskDropsCrown", 1);
	limited_add_entry($familiar[trick-or-treating tot], $items[hoarded candy wad], 1, "_hoardedCandyDropsCrown", 3);
	limited_add_entry($familiar[optimistic candle], $items[glob of melted wax], 1, "_optimisticCandleDropsCrown", 3);
	limited_add_entry($familiar[adventurous spelunker], $items[bubblewrap ore, cardboard ore, styrofoam ore, teflon ore, velcro ore, vinyl ore], 1, "_oreDropsCrown", 6);
	limited_add_entry($familiar[twitching space critter], $items[space beast fur], 1, "_spaceFurDropsCrown", 1);

	return res;
}

item wadify(item nugget)
{
	switch(nugget)
	{
	case $item[hot nuggets]: return $item[hot wad];
	case $item[cold nuggets]: return $item[cold wad];
	case $item[sleaze nuggets]: return $item[sleaze wad];
	case $item[stench nuggets]: return $item[stench wad];
	case $item[spooky nuggets]: return $item[spooky wad];
	case $item[twinkly nuggets]: return $item[twinkly wad];
	default: return $item[none];
	}
}

int get_price(item it)
{
	int dropVal = mall_price(it);
	if(dropVal == max(100, 2 * autosell_price(it)))
	{
		item wad = wadify(it);
		if(wad != $item[none])
		{
			return max(mall_price(wad) / 5, autosell_price(it));
		}
		return autosell_price(it);
	}
	return dropVal;
}

float bjorn_average_value(bjorn_data bd)
{
	float value = 0;
	foreach i, it in bd.drops
	{
		value += get_price(it);
	}
	value /= bd.drops.count();
	value *= bd.dropChance;
	return value;
}

bjorn_data [int] get_bjorn_data_sorted(boolean includeUnowned)
{
	bjorn_data [int] data = get_bjorn_data(includeUnowned);
	sort data by bjorn_average_value(value);
	return data;
}

bjorn_data get_best_bjorn_data()
{
	bjorn_data [int] data = get_bjorn_data_sorted(false);
	return data[data.count() - 1];
}

familiar get_best_bjorn()
{
	return get_best_bjorn_data().fam;
}

void main()
{
	foreach i, bd in get_bjorn_data_sorted(true)
	{
		print(bd.fam.to_string() + ": " + bjorn_average_value(bd) + (bd.limited ? " (limited!)" : ""), (have_familiar(bd.fam) ? "green" : "red"));
	}
}
