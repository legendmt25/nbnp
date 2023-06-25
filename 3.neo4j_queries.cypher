match (test: Test) return test;
match (test: Test) return test limit 300;
match (test: Test) return test order by test.quantity;

match (color: Color)<-[:COLOR]-(test: Test) return test, color;
match (color: Color)<-[:COLOR]-(test: Test) return test, color limit 300;

match (color: Color)<-[r_color:COLOR]-(test: Test) return r_color;

match (color: Color)<-[r_color:COLOR]-(test: Test)
match (test)-[r_breed: BREED]-(breed: Breed)
return breed, test, color;

match (color: Color)<-[r_color:COLOR]-(test: Test)
with color, test, r_color
match (test)-[r_breed: BREED]-(breed: Breed)
return breed, test, color;

match (color: Color)<-[r_color:COLOR]-(test: Test)
match (test)-[r_breed: BREED]-(breed: Breed)
where breed.name = 'Husky'
return breed, test, color;

match (color: Color)<-[r_color:COLOR]-(test: Test)
match (test)-[r_breed: BREED]-(breed: Breed)
where breed.name = 'Husky'
return breed, test, color
order by test.age;

// Get huskies max age
match (test)-[r_breed: BREED]-(breed: Breed)
where breed.name = 'Husky'
return max(test.age);


// Error here because we are using aggregation function inside where clause
match (test: Test)--(breed:Breed)
where breed.name = 'Husky' and test.age = max(test.age)
return test;

// To get the age we need to use 'with' to return the result and use it in the next query
match (test: Test)--(breed:Breed)
where breed.name = 'Husky'
with max(test.age) as max_husky_age
match (test: Test)--(breed: Breed)
where breed.name = 'Husky' and max_husky_age = test.age
return test;

// To get all the relations we can connect test to rels with two dashes, without specifying which relations we want to get all relations
match (test: Test)--(breed:Breed)
where breed.name = 'Husky'
with max(test.age) as max_husky_age
match (rels)--(test: Test)--(breed: Breed)
where breed.name = 'Husky' and max_husky_age = test.age
return test, breed, rels;


// Get dogs with unknown breed
optional match (test: Test)--(breed: Breed) return test, breed;

// Find all available filters for female dog breeds in a certain State who are female, are not sterilized and have a white colored fur
match (pet: Test)-[r_state: STATE]->(state: State),
      (pet)-[r_color: COLOR]->(color: Color),
      (breed: Breed)<-[r_breed: BREED]-(pet)
where state.id = 41324
  and color.name = 'White' and breed.type = 'DOG'
  and pet.gender = 'FEMALE' and pet.sterilized = 'NO'
return breed;

// Find all female dogs by color, state and breed, order by age and fee
match (pet: Test)-[r_state: STATE]->(state: State),
      (pet)-[r_color: COLOR]->(color: Color),
      (breed: Breed)<-[r_breed: BREED]-(pet)
where state.id = 41324 and color.name = 'White'
  and breed.type = 'DOG' and breed.id = 307
  and pet.gender = 'FEMALE' and pet.sterilized = 'NO'
return pet
order by pet.age asc, pet.fee
skip 0 /* (page - 1) * size */
limit 10 /* size */;


// find all states that have a husky
match (pet: Test)-[r_breed: BREED]->(breed: Breed),
      (state: State)<-[r_state: STATE]-(pet)
where pet.name = 'Husky'
return distinct state.name as name, state.id as id;


// find all available husky colors and the count of huskies with that color
match (pet: Test)-[r_breed:BREED]->(breed: Breed),
      (color: Color)<-[r_color:COLOR]-(pet)
where breed.name = 'Husky'
return color.id as ColorID, color.name as colorName, count(pet) as huskies
order by huskies desc;