# ------------------------------------------------------------------------------
# Public Subnet 1 - ap-south-1a
# ------------------------------------------------------------------------------

resource "aws_subnet" "public_1a" {

  vpc_id = data.aws_vpc.existing.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = local.az_1

  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {

    Name = "ramesh-eks-public-subnet-1a"
  })
}

# ------------------------------------------------------------------------------
# Public Subnet 2 - ap-south-1c
# ------------------------------------------------------------------------------

resource "aws_subnet" "public_1c" {

  vpc_id = data.aws_vpc.existing.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = local.az_2

  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {

    Name = "ramesh-eks-public-subnet-1c"
  })
}

# ------------------------------------------------------------------------------
# Public Route Table
# ------------------------------------------------------------------------------

resource "aws_route_table" "public_rt" {

  vpc_id = data.aws_vpc.existing.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = data.aws_internet_gateway.existing_igw.id
  }

  tags = merge(local.common_tags, {

    Name = "ramesh-eks-public-rt"
  })
}

# ------------------------------------------------------------------------------
# Route Table Association - Subnet 1a
# ------------------------------------------------------------------------------

resource "aws_route_table_association" "public_assoc_1a" {

  subnet_id = aws_subnet.public_1a.id

  route_table_id = aws_route_table.public_rt.id
}

# ------------------------------------------------------------------------------
# Route Table Association - Subnet 1c
# ------------------------------------------------------------------------------

resource "aws_route_table_association" "public_assoc_1c" {

  subnet_id = aws_subnet.public_1c.id

  route_table_id = aws_route_table.public_rt.id
}
