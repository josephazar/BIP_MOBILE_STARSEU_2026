const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  const attributes = {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      autoIncrement: true,
      field: "id"
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false,
      field: "name"
    },
    mobile_number: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true,
      field: "mobile_number"
    },
    email_address: {
      type: DataTypes.STRING(255),
      allowNull: false,
      field: "email_address"
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false,
      field: "password"
    },
    active: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: 0,
      field: "active"
    },
    otp: {
      type: DataTypes.STRING(8),
      allowNull: true,
      defaultValue: null,
      field: "otp"
    },
    password_reset_code: {
      type: DataTypes.STRING(255),
      allowNull: true,
      field: "password_reset_code"
    },
    status: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: 1,
      field: "status"
    },
    created_at: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: DataTypes.NOW,
      field: "created_at"
    },
    updated_at: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "updated_at"
    }
  };

  const options = {
    tableName: "ac_users",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
    indexes: [{
      unique: true,
      fields: ['mobile_number'],
    }]
  };

  return sequelize.define("UsersModel", attributes, options);
};
