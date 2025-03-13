import Time "mo:base/Time";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Vector "mo:vector";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Map "mo:map/Map";

module {
  // Log levels for filtering
  public type LogLevel = {
    #INFO;
    #WARN;
    #ERROR;
  };

  // Log entry structure
  public type LogEntry = {
    timestamp : Int;
    level : LogLevel;
    component : Text;
    message : Text;
    context : Text;
  };

  // Log storage using Vector for efficient push/pop operations
  public class Logger() {
    // Store logs in a circular vector with fixed size
    private let MAX_LOGS = 50000;
    private let logs = Vector.new<LogEntry>();

    // Context-specific log storage
    private let contextLogs = Map.new<Text, Vector.Vector<LogEntry>>();

    // Helper to format log level as text
    private func levelToText(level : LogLevel) : Text {
      switch (level) {
        case (#INFO) { "INFO" };
        case (#WARN) { "WARN" };
        case (#ERROR) { "ERROR" };
      };
    };

    // Create and store a log entry
    private func createLogEntry(level : LogLevel, component : Text, message : Text, context : Text) : LogEntry {
      let entry = {
        timestamp = Time.now();
        level;
        component;
        message;
        context;
      };

      // Add to main log vector
      Vector.add(logs, entry);

      // Maintain max size by removing oldest entries if needed
      if (Vector.size(logs) > MAX_LOGS) {
        Vector.reverse(logs);
        while (Vector.size(logs) > MAX_LOGS) {
          ignore Vector.removeLast(logs);
        };
        Vector.reverse(logs);
      };

      // Add to context-specific log vector
      switch (Map.get(contextLogs, Map.thash, context)) {
        case (null) {
          let contextVector = Vector.new<LogEntry>();
          Vector.add(contextVector, entry);
          Map.set(contextLogs, Map.thash, context, contextVector);
        };
        case (?vector) {
          Vector.add(vector, entry);

          // Maintain max size for context logs
          if (Vector.size(vector) > 100) {
            Vector.reverse(vector);
            while (Vector.size(vector) > 100) {
              ignore Vector.removeLast(vector);
            };
            Vector.reverse(vector);
          };
        };
      };

      // Print log to console
      Debug.print("[" # levelToText(level) # "] [" # Int.toText(entry.timestamp) # "] [" # component # "] " # message # " | Context: " # context);
      entry;
    };

    // Public logging methods
    public func info(component : Text, message : Text, context : Text) {
      ignore createLogEntry(#INFO, component, message, context);
    };

    public func warn(component : Text, message : Text, context : Text) {
      ignore createLogEntry(#WARN, component, message, context);
    };

    public func error(component : Text, message : Text, context : Text) {
      ignore createLogEntry(#ERROR, component, message, context);
    };

    // Add multiple log entries at once
    public func addEntries(entries : [(LogLevel, Text, Text, Text)]) {
      for ((level, component, message, context) in entries.vals()) {
        ignore createLogEntry(level, component, message, context);
      };
    };

    // Get the last N logs
    public func getLastLogs(last : Nat) : [LogEntry] {
      let size = Vector.size(logs);
      if (size == 0) {
        return [];
      };

      let count = if (last > size) { size } else { last };
      let startIdx = size - count;

      let result = Vector.new<LogEntry>();
      for (i in Iter.range(startIdx, size - 1)) {
        Vector.add(result, Vector.get(logs, i));
      };

      Vector.toArray(result);
    };

    // Get the last N logs for a specific context
    public func getContextLogs(context : Text, last : Nat) : [LogEntry] {
      switch (Map.get(contextLogs, Map.thash, context)) {
        case (null) { [] };
        case (?vector) {
          let size = Vector.size(vector);
          if (size == 0) {
            return [];
          };

          let count = if (last > size) { size } else { last };
          let startIdx = size - count;

          let result = Vector.new<LogEntry>();
          for (i in Iter.range(startIdx, size - 1)) {
            Vector.add(result, Vector.get(vector, i));
          };

          Vector.toArray(result);
        };
      };
    };

    // Get all available contexts
    public func getContexts() : [Text] {
      Iter.toArray(Map.keys(contextLogs));
    };

    // Filter logs by level
    public func getLogsByLevel(level : LogLevel, last : Nat) : [LogEntry] {
      let filtered = Vector.new<LogEntry>();

      for (entry in Vector.vals(logs)) {
        if (entry.level == level) {
          Vector.add(filtered, entry);
        };
      };

      let size = Vector.size(filtered);
      if (size == 0) {
        return [];
      };

      let count = if (last > size) { size } else { last };
      let startIdx = size - count;

      let result = Vector.new<LogEntry>();
      for (i in Iter.range(startIdx, size - 1)) {
        Vector.add(result, Vector.get(filtered, i));
      };

      Vector.toArray(result);
    };

    // Clear logs
    public func clearLogs() {
      Vector.clear(logs);
    };

    // Clear context logs
    public func clearContextLogs(context : Text) {
      switch (Map.get(contextLogs, Map.thash, context)) {
        case (null) {};
        case (?vector) {
          Vector.clear(vector);
        };
      };
    };
  };
};
