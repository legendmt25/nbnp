match (n) detach delete n;

load csv with headers from 'file:///ColorLabels.csv' as row
merge (:Color {
    id: toInteger(row.ColorID), 
    name: row.ColorName
});

load csv with headers from 'file:///BreedLabels.csv' as row
merge (:Breed {
    id: toInteger(row.BreedID), 
    type: 
        case toInteger(row.Type)
            when 1 then 'DOG'
            when 2 then 'CAT'
        end,
    name: row.BreedName
});

load csv with headers from 'file:///StateLabels.csv' as row
merge (:State {
    id: toInteger(row.StateID), 
    name: row.StateName
});

load csv with headers from 'file:///SampleSubmission.csv' as row
merge (:Submission {
    petId: row.PetID, 
    adoptionSpeed: toInteger(row.AdoptionSpeed)
});

load csv with headers from 'file:///Test.csv' as row
merge (test: Test {
    fee: toInteger(row.Fee),
    quantity: toInteger(row.Quantity),
    age: toInteger(row.Age),
    description: row.Description,
    gender: 
        case toInteger(row.Gender)
            when 1 then 'MALE'
            when 2 then 'FEMALE'
            when 3 then 'MIXED'
        end,
    maturitySize: 
        case toInteger(row.MaturitySize)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'SMALL'
            when 2 then 'MEDIUM'
            when 3 then 'LARGE'
            when 4 then 'EXTRA_LARGE'
        end,
    furLength: 
        case toInteger(row.FurLength)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'SHORT'
            when 2 then 'MEDIUM'
            when 3 then 'LONG'
        end,
    vaccinated: 
        case toInteger(row.Vaccinated)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    dewormed:
        case toInteger(row.Dewormed)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    sterilized: 
        case toInteger(row.Sterilized)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    health: 
        case toInteger(row.Health)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'HEALTHY'
            when 2 then 'MINOR_INJURY'
            when 3 then 'SERIOUS_INJURY'
        end,
    videoAmt: toInteger(row.VideoAmt),
    photoAmt: toInteger(row.PhotoAmt),
    rescuerId: row.RescuerID,
    petId: row.PetID,
    color1: toInteger(row.Color1),
    color2: toInteger(row.Color2),
    color3: toInteger(row.Color3),
    breed1: toInteger(row.Breed1),
    breed2: toInteger(row.Breed2),
    state: toInteger(row.State)
}) set test.name = row.Name;

load csv with headers from 'file:///Train.csv' as row
merge (test: Test {
    fee: toInteger(row.Fee),
    quantity: toInteger(row.Quantity),
    age: toInteger(row.Age),
    description: row.Description,
    gender: 
        case toInteger(row.Gender)
            when 1 then 'MALE'
            when 2 then 'FEMALE'
            when 3 then 'MIXED'
        end,
    maturitySize: 
        case toInteger(row.MaturitySize)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'SMALL'
            when 2 then 'MEDIUM'
            when 3 then 'LARGE'
            when 4 then 'EXTRA_LARGE'
        end,
    furLength: 
        case toInteger(row.FurLength)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'SHORT'
            when 2 then 'MEDIUM'
            when 3 then 'LONG'
        end,
    vaccinated: 
        case toInteger(row.Vaccinated)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    dewormed:
        case toInteger(row.Dewormed)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    sterilized: 
        case toInteger(row.Sterilized)
            when 1 then 'YES'
            when 2 then 'NO'
            when 3 then 'NOT_SURE'
        end,
    health: 
        case toInteger(row.Health)
            when 0 then 'NOT_SPECIFIED'
            when 1 then 'HEALTHY'
            when 2 then 'MINOR_INJURY'
            when 3 then 'SERIOUS_INJURY'
        end,
    videoAmt: toInteger(row.VideoAmt),
    photoAmt: toInteger(row.PhotoAmt),
    rescuerId: row.RescuerID,
    petId: row.PetID,
    color1: toInteger(row.Color1),
    color2: toInteger(row.Color2),
    color3: toInteger(row.Color3),
    breed1: toInteger(row.Breed1),
    breed2: toInteger(row.Breed2),
    state: toInteger(row.State)
}) set test.name = row.Name;

match (test: Test)
match (color: Color) where 
    test.color1 = color.id or 
    test.color2 = color.id or 
    test.color3 = color.id
merge (test)-[:COLOR]->(color);

match (test: Test)
match (breed: Breed) where 
    test.breed1 = breed.id or 
    test.breed2 = breed.id
merge (test)-[:BREED]->(breed);

match (test: Test)
match (state: State) where 
    test.state = state.id
merge (test)-[:STATE]->(state);

match (test: Test)
remove 
    test.state, 
    test.color1, 
    test.color2, 
    test.color3, 
    test.breed1, 
    test.breed2;