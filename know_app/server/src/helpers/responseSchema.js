export default (success, message, result) => {
    if (success === true) return { success, msg: message, data: result };
    else if (success === false)
        return {
            success,
            message: message.toString() || 'An error occurred',
        };
    else throw new Error('Invalid response schema');
};
