select from Test;
select from Test skip 100 limit 50;
select from Test order by Quantity desc;

select in as color, out as test from HAS_COLOR;
select in as color, out as test from HAS_COLOR limit 300;

select *, outE('HAS_BREED').in.Name as Breed, outE('HAS_COLOR').in.Name as Color from Test;

select *, $breed as Breed, $color as Color from Test
let $breed = outE('HAS_BREED').in.Name, $color = outE('HAS_COLOR').in.Name
where 'Husky' in $breed;

select *, $breed as Breed, $color as Color from Test
let $breed = outE('HAS_BREED').in.Name, $color = outE('HAS_COLOR').in.Name
where 'Husky' in $breed
order by Age;

-- Get huskies max age
select Age from Test
let $breed = outE('HAS_BREED').in.Name
where 'Husky' in $breed
order by Age desc
limit 1;

-- Error here because we are using aggregation function inside where clause
select Age from Test
let $breed = outE('HAS_BREED').in.Name
where 'Husky' in $breed and max(Age)
order by Age desc
limit 1;

select from Test
let $breed = outE('HAS_BREED').in.Name
where 'Husky' in $breed
order by Age desc
limit 1;

-- find all pets in region
select expand(pet) from HAS_STATE
let state = in, pet = out
where state.ID = 41326


-- Find all available filters for female dog breeds in a certain State who are female, are not sterilized and have a white colored fur
match { class: Test, as: pet, where: (Gender = 'FEMALE' and Sterilized = 'NO') }-HAS_STATE->{ class: State, as: state, where: (ID = 41324) },
      { class: Test, as: pet, where: (Gender = 'FEMALE' and Sterilized = 'NO') }-HAS_COLOR->{ class: Color, as: color, where: (Name = 'White')},
      { class: Test, as: pet, where: (Gender = 'FEMALE' and Sterilized = 'NO') }-HAS_BREED->{ class: Breed, as: breed, where: (Type = 'DOG') }
return expand(breed)

match { class: Test, as: pet, where: (Gender = 'FEMALE' and Sterilized = 'NO') }-HAS_STATE->{class: State, as: state, where: (ID = 41324)},
      { class: Test, as: pet }-HAS_COLOR->{class: Color, as: color, where: (Name = 'White')},
      { class: Breed, as: breed, where: (Type = 'DOG') }<-HAS_BREED-{ class: Test, as: pet }
return expand(breed);

-- Find all female dogs by color, state and breed, order by age and fee
match { class: Test, as: pet, where: (Gender = 'FEMALE' and Sterilized = 'NO') }-HAS_STATE->{class: State, as: state, where: (ID = 41324)},
      { class: Test, as: pet }-HAS_COLOR->{class: Color, as: color, where: (Name = 'White')},
      { class: Test, as: pet }-HAS_BREED->{class: Breed, as: breed, where: (ID = 307 and Type = 'DOG')}
return expand(pet)
order by pet.Age asc, pet.Fee asc
skip 0 -- (page - 1) * size
limit 10; -- size

-- find all states that have a husky
match { class: Test, as: pet }-HAS_BREED->{class: Breed, as: breed, where: (Name = 'Husky')},
      { class: State, as: state }<-HAS_STATE-{ class: Test, as: pet }
return distinct state.Name, state.ID

-- find all states what have huskies and get the number for each state
match { class: Test, as: pet }-HAS_BREED->{class: Breed, as: breed, where: (Name = 'Husky')},
      { class: State, as: state }<-HAS_STATE-{ class: Test, as: pet }
return state.Name as stateName, state.ID as stateId, count(pet) as petCount
group by state.Name, state.ID
order by petCount desc

-- find all available husky colors and the count of huskies with that color
match { class: Test, as: pet }-HAS_BREED->{class: Breed, as: breed, where: (Name = 'Husky')},
      { class: Color, as: color }<-HAS_COLOR-{ class: Test, as: pet }
return distinct color.ID as ColorID, color.Name as ColorName, count(pet) as Huskies
group by color.Name, Color.ID
order by Huskies desc
