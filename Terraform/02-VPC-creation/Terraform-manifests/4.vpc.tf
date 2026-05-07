# Resource-1: Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = local.az
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "Ramesh-06-pub-subnet"
  })
}

# Resource-2: Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.existing.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = local.az

  tags = merge(local.common_tags, {
    Name = "Ramesh-06-priv-subnet"
  })
}

# Resource-3: Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "ramesh-bootcamp-nat-eip"
  })
}

# Resource-4: NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge(local.common_tags, {
    Name = "ramesh-bootcamp-nat"
  })

  depends_on = [data.aws_internet_gateway.existing_igw]
}

# Resource-5: Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "ramesh-public-rt"
  })
}

# Resource-6: Public Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Resource-7: Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block     = "10.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.common_tags, {
    Name = "ramesh-private-rt"
  })
}

# Resource-8: Private Route Table Association
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
