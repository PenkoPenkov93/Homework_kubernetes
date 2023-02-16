# File to store the user data
user_db="user_db.csv"

# Check if the file exists and create it if not
if [ ! -f "$user_db" ]; then
  touch "$user_db"
  echo "Bosch ID,Name,Surname,Region,Email" >> "$user_db"
fi

# Read the input from a file
while IFS="," read -r name surname region; do
  # Convert the region to lowercase
  region=$(echo "$region" | tr '[:upper:]' '[:lower:]')

  # Set the office based on the region
  if [ "$region" == "bulgaria" ]; then
    office="sf"
  elif [ "$region" == "germany" ]; then
    office="de"
  else
    office="eu"
  fi

  # Generate the Bosch ID
  bosch_id=$(echo "${surname:0:2}${name:0:1}${office}" | tr '[:upper:]' '[:lower:]')

  # Find the next available sequence number
  max_num=0
  while read -r line; do
    id=$(echo "$line" | cut -d "," -f 1 | awk -F "$bosch_id" '{print $2}')
    if [ "$id" -gt "$max_num" ]; then
      max_num="$id"
    fi
  done < "$user_db"
  bosch_id="$bosch_id$((max_num + 1))"

  # Generate the email
  email="$bosch_id@bosch.com"

  # Write the data to the file
  echo "$bosch_id,$name,$surname,$region,$email" >> "$user_db"
done < input.txt
